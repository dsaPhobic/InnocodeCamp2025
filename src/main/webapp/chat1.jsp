<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Message" %>
<%@ page import="java.util.Base64" %>
<%@ page import="java.io.*" %>
<%
    List<Message> chatHistory = (List<Message>) session.getAttribute("chatHistory");
    if (chatHistory == null) {
        chatHistory = new java.util.ArrayList<>();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Career Chatbot | GlobalWorks</title>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://unpkg.com/lucide@latest"></script>
    <script src="https://cdn.jsdelivr.net/npm/marked/marked.min.js"></script>
<style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', system-ui, sans-serif;
        }

        /* Floating Chat Widget */
        .chat-widget {
            position: fixed;
            bottom: 30px;
            right: 30px;
            width: 90px;
            height: 32px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 16px;
            box-shadow: 0 2px 8px rgba(102, 126, 234, 0.2);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1000;
            transform: translateY(100px);
            opacity: 0;
            animation: slideUp 0.5s ease-out forwards;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .chat-widget:hover {
            transform: scale(1.08) translateY(-1px);
            box-shadow: 0 4px 16px rgba(102, 126, 234, 0.3);
            border-color: rgba(255, 255, 255, 0.2);
        }

        .chat-widget:active {
            transform: scale(0.96);
        }

        /* Chat Modal */
        .chat-modal {
            position: fixed;
            bottom: 30px;
            right: 30px;
            width: 450px;
            height: 560px;
            background: #fff;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15);
            display: none;
            flex-direction: column;
            overflow: hidden;
            z-index: 1001;
        }

        .chat-modal.show {
            display: flex;
            animation: modalSlideUp 0.3s ease-out;
        }

        @keyframes modalSlideUp {
            from {
                opacity: 0;
                transform: translateY(20px) scale(0.9);
            }
            to {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }

        @keyframes slideUp {
        to {
                transform: translateY(0);
            opacity: 1;
            }
        }

        /* Chat Header */
        .chat-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #fff;
            padding: 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: relative;
        }

        .chat-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            opacity: 0.9;
        }

        .chat-header-content {
            position: relative;
            z-index: 1;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .chat-avatar {
            width: 40px;
            height: 40px;
            background: rgba(255, 255, 255, 0.2);
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
            font-size: 1.2rem;
        }

        .chat-info h3 {
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 2px;
        }

        .chat-info p {
            font-size: 0.8rem;
            opacity: 0.9;
        }

        .chat-close {
        position: relative;
            z-index: 1;
            background: rgba(255, 255, 255, 0.2);
        border: none;
        color: #fff;
            width: 32px;
            height: 32px;
            border-radius: 50%;
        cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s;
        }

        .chat-close:hover {
            background: rgba(255, 255, 255, 0.3);
            transform: scale(1.1);
        }

        /* Chat Messages */
        .chat-messages {
        flex: 1;
            padding: 20px;
        overflow-y: auto;
            background: #f8fafc;
        }

        .message {
            margin-bottom: 16px;
        display: flex;
            gap: 8px;
            animation: messageSlideIn 0.3s ease-out;
        }

        @keyframes messageSlideIn {
            from {
                opacity: 0;
                transform: translateY(10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .message.user {
            flex-direction: row-reverse;
        }

        .message-avatar {
            width: 32px;
            height: 32px;
            border-radius: 50%;
        display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.8rem;
            font-weight: 600;
            flex-shrink: 0;
        }

        .message.user .message-avatar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #fff;
        }

        .message.assistant .message-avatar {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: #fff;
        }

        .message-content {
            max-width: 75%;
            padding: 12px 16px;
        border-radius: 18px;
            font-size: 0.9rem;
            line-height: 1.4;
        }

        .message.user .message-content {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #fff;
            border-bottom-right-radius: 6px;
        }

        .message.assistant .message-content {
            background: #fff;
            border: 1px solid #e2e8f0;
            border-bottom-left-radius: 6px;
            color: #1e293b;
        }

                /* Welcome Section */
        .welcome-section {
            text-align: center;
            padding: 25px 20px 20px 20px;
            color: #64748b;
        }

        .welcome-section h3 {
            color: #1e293b;
            margin-bottom: 12px;
            font-size: 1.1rem;
            font-weight: 600;
        }

        .welcome-section p {
            font-size: 0.9rem;
            margin-bottom: 20px;
            line-height: 1.5;
        }

        /* Quick Suggestions */
        .quick-suggestions {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 8px;
            margin-bottom: 20px;
        }

        .suggestion-btn {
            background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 10px 12px;
            font-size: 0.8rem;
            color: #1e293b;
            cursor: pointer;
            transition: all 0.2s;
            text-align: left;
            line-height: 1.3;
        }

        .suggestion-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            border-color: #667eea;
            background: linear-gradient(135deg, #f0f4ff 0%, #e6f0ff 100%);
        }

        /* Chat Input */
        .chat-input {
            padding: 15px 20px 12px 20px;
            background: #fff;
            border-top: 1px solid #e2e8f0;
        }

        .input-container {
        display: flex;
            gap: 10px;
            align-items: flex-end;
    }

        .input-wrapper {
        flex: 1;
            position: relative;
        }

        .chat-textarea {
            width: 100%;
            min-height: 50px;
            max-height: 120px;
            padding: 12px 16px;
            border: 2px solid #e2e8f0;
            border-radius: 20px;
            font-size: 1rem;
            font-family: inherit;
            resize: none;
            outline: none;
            transition: border-color 0.2s;
            background: #f8fafc;
        }

        .chat-textarea:focus {
            border-color: #667eea;
            background: #fff;
        }

        .send-btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: #fff;
        border: none;
            border-radius: 50%;
            width: 50px;
            height: 50px;
        cursor: pointer;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .send-btn:hover {
            transform: scale(1.1);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }

        .send-btn:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
        }

        /* Typing Indicator */
        .typing-indicator {
            display: none;
            padding: 12px 16px;
            background: #fff;
            border: 1px solid #e2e8f0;
            border-radius: 18px;
            margin-bottom: 16px;
            border-bottom-left-radius: 6px;
        }

        .typing-dots {
            display: flex;
            gap: 4px;
            align-items: center;
        }

        .typing-dot {
            width: 6px;
            height: 6px;
            background: #667eea;
            border-radius: 50%;
            animation: typing 1.4s infinite;
        }

        .typing-dot:nth-child(2) {
            animation-delay: 0.2s;
        }

        .typing-dot:nth-child(3) {
            animation-delay: 0.4s;
        }

        @keyframes typing {
            0%, 60%, 100% {
                transform: translateY(0);
            }
            30% {
                transform: translateY(-8px);
            }
        }

                /* Minimized State */
        .chat-widget.minimized {
            height: 70px;
            cursor: pointer;
        }

        .chat-widget.minimized .chat-messages,
        .chat-widget.minimized .chat-input {
            display: none;
        }

        /* Default minimized state */
        .chat-widget {
            height: 70px;
        }

        .chat-widget .chat-messages,
        .chat-widget .chat-input {
            display: none;
        }

        /* Expanded state */
        .chat-widget.expanded {
            height: 600px;
        }

        .chat-widget.expanded .chat-messages,
        .chat-widget.expanded .chat-input {
            display: flex;
        }

        /* Responsive */
        @media (max-width: 480px) {
            .chat-widget {
                width: calc(100vw - 40px);
                right: 20px;
                left: 20px;
                bottom: 20px;
            }

            .quick-suggestions {
                grid-template-columns: 1fr;
            }
        }

        /* Scrollbar Styling */
        .chat-messages::-webkit-scrollbar {
            width: 6px;
        }

        .chat-messages::-webkit-scrollbar-track {
            background: transparent;
        }

        .chat-messages::-webkit-scrollbar-thumb {
            background: #cbd5e1;
            border-radius: 3px;
        }

        .chat-messages::-webkit-scrollbar-thumb:hover {
            background: #94a3b8;
    }
</style>
</head>
<body>
        <div class="chat-widget" id="chat-widget">
            <i data-lucide="message-circle" style="color: white; width: 14px; height: 14px; margin-right: 4px;"></i>
            <span style="color: white; font-size: 11px; font-weight: 600; letter-spacing: 0.3px;">Chat</span>
        </div>

    <!-- Chat Modal -->
    <div id="chat-modal" class="chat-modal">
        <div class="chat-modal-content">
            <div class="chat-header">
                <div class="chat-header-content">
                    <div class="chat-avatar">
                        <i data-lucide="bot"></i>
                    </div>
                    <div class="chat-info">
                        <h3>Career Assistant</h3>
                        <p>Chuyên về nghề nghiệp IT</p>
                    </div>
                </div>
                <button class="chat-close" id="chat-close">
                    <i data-lucide="x"></i>
                </button>
            </div>

        <div class="chat-messages" id="chat-messages">
        <% if (chatHistory.isEmpty()) { %>
                <div class="welcome-section">
                    <h3>👋 Xin chào!</h3>
                    <p>Tôi là trợ lý AI chuyên về nghề nghiệp IT. Hãy hỏi tôi bất cứ điều gì về sự nghiệp, kỹ năng, hay cơ hội việc làm!</p>
                    
                    <div class="quick-suggestions">
                        <button class="suggestion-btn" onclick="sendSuggestion('Kỹ năng backend?')">
                            🚀 Kỹ năng backend?
                        </button>
                        <button class="suggestion-btn" onclick="sendSuggestion('Lộ trình front-end?')">
                            🎨 Lộ trình front-end?
                        </button>
                        <button class="suggestion-btn" onclick="sendSuggestion('Lương ngành IT?')">
                            💰 Lương ngành IT?
                        </button>
                        <button class="suggestion-btn" onclick="sendSuggestion('Cách viết CV IT?')">
                            📝 Cách viết CV IT?
                        </button>
                    </div>
                </div>
            <% } else { %>
                <% for (Message message : chatHistory) { %>
                    <div class="message <%= message.getRole() %>">
                        <div class="message-avatar">
                            <% if (message.getRole().equals("user")) { %>
                                <i data-lucide="user"></i>
                            <% } else { %>
                                <i data-lucide="bot"></i>
                            <% } %>
                        </div>
                        <div class="message-content">
                            <% if (message.hasImage()) { %>
                                <img src="data:image/png;base64,<%= message.getBase64Image() %>" alt="Uploaded image" style="max-width: 200px; border-radius: 8px; margin-top: 8px;">
                            <% } %>
                            <% if (message.hasText()) { %>
                                <div id="markdown-content-<%= message.hashCode() %>"></div>
                                <script>
                                    document.getElementById('markdown-content-<%= message.hashCode() %>').innerHTML = 
                                        marked.parse('<%= message.getText().replace("'", "\\'").replace("\n", "\\n") %>');
                                </script>
                            <% } %>
                        </div>
                    </div>
                <% } %>
            <% } %>
        </div>

        <div class="typing-indicator" id="typing-indicator">
            <div class="typing-dots">
                <div class="typing-dot"></div>
                <div class="typing-dot"></div>
                <div class="typing-dot"></div>
            </div>
        </div>

        <div class="chat-input">
            <form id="chat-form">
                <div class="input-container">
                    <div class="input-wrapper">
                        <textarea 
                            id="user-input" 
                            class="chat-textarea" 
                            placeholder="Hỏi về nghề IT, lập trình, kỹ năng, lương..."
                            rows="1"
                        ></textarea>
                    </div>
                    <button type="submit" class="send-btn" id="send-btn">
                        <i data-lucide="send"></i>
                    </button>
    </div>
    </form>
        </div>
    </div>

<script>
        lucide.createIcons();

        const chatWidget = document.getElementById('chat-widget');
        const chatModal = document.getElementById('chat-modal');
        const chatMessages = document.getElementById('chat-messages');
        const chatForm = document.getElementById('chat-form');
        const userInput = document.getElementById('user-input');
        const sendBtn = document.getElementById('send-btn');
        const typingIndicator = document.getElementById('typing-indicator');
        const chatClose = document.getElementById('chat-close');

        // Open chat modal when balloon is clicked
        chatWidget.addEventListener('click', function() {
            chatModal.classList.add('show');
            lucide.createIcons();
        });

        // Close chat modal
        chatClose.addEventListener('click', function() {
            chatModal.classList.remove('show');
        });

        // Auto-resize textarea
        userInput.addEventListener('input', function() {
            this.style.height = 'auto';
            this.style.height = Math.min(this.scrollHeight, 100) + 'px';
        });

        // Send message function
        function sendMessage(content) {
            // Add user message
            const userMessage = createMessage('user', content);
            chatMessages.appendChild(userMessage);
            scrollToBottom();

            // Show typing indicator
            typingIndicator.style.display = 'block';
            scrollToBottom();

            // Send to server
            fetch('ChatbotServlet', {
                        method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'message=' + encodeURIComponent(content)
                    })
            .then(response => response.text())
                            .then(data => {
                // Hide typing indicator
                typingIndicator.style.display = 'none';
                
                // Add assistant response
                const assistantMessage = createMessage('assistant', data);
                chatMessages.appendChild(assistantMessage);
                scrollToBottom();
            })
            .catch(error => {
                console.error('Error:', error);
                typingIndicator.style.display = 'none';
            });
        }

        // Create message element
        function createMessage(role, content) {
            const messageDiv = document.createElement('div');
            messageDiv.className = `message ${role}`;
            
            const avatar = document.createElement('div');
            avatar.className = 'message-avatar';
            avatar.innerHTML = role === 'user' ? '<i data-lucide="user"></i>' : '<i data-lucide="bot"></i>';
            
            const contentDiv = document.createElement('div');
            contentDiv.className = 'message-content';
            
            const markdownDiv = document.createElement('div');
            markdownDiv.innerHTML = marked.parse(content);
            contentDiv.appendChild(markdownDiv);
            
            messageDiv.appendChild(avatar);
            messageDiv.appendChild(contentDiv);
            
            // Recreate icons
            setTimeout(() => lucide.createIcons(), 100);
            
            return messageDiv;
        }

        // Send suggestion
        function sendSuggestion(text) {
            userInput.value = text;
            sendMessage(text);
        }

        // Scroll to bottom
        function scrollToBottom() {
            chatMessages.scrollTop = chatMessages.scrollHeight;
        }

        // Form submit
        chatForm.addEventListener('submit', function(e) {
            e.preventDefault();
            const message = userInput.value.trim();
            if (message) {
                sendMessage(message);
                userInput.value = '';
                userInput.style.height = 'auto';
            }
        });

        // Initial scroll
        scrollToBottom();
</script>
</body>
</html>
