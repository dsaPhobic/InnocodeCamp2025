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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar.css" />
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
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            color: #1e293b;
        }

        /* Hero Section */
        .hero {
            background: linear-gradient(to right, #2563eb, #7c3aed);
            color: #fff;
            padding: 3rem 0 2rem 0;
            text-align: center;
        }

        .hero h1 {
            font-size: 2.5rem;
            font-weight: bold;
            margin-bottom: 1rem;
        }

        .hero p {
            font-size: 1.125rem;
            color: #dbeafe;
            max-width: 600px;
            margin: 0 auto;
        }

        /* Chat Container */
        .chat-container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 1rem;
            display: grid;
            grid-template-columns: 1fr 400px;
            gap: 2rem;
            min-height: 70vh;
        }

        /* Main Chat Area */
        .main-chat {
            background: #fff;
            border-radius: 1rem;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            display: flex;
            flex-direction: column;
            height: 70vh;
        }

        .chat-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #fff;
            padding: 1.5rem;
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .chat-avatar {
            width: 48px;
            height: 48px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
        }

        .chat-info h3 {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 0.25rem;
        }

        .chat-info p {
            font-size: 0.875rem;
            opacity: 0.9;
        }

        .chat-messages {
            flex: 1;
            padding: 1.5rem;
            overflow-y: auto;
            background: #f8fafc;
        }

        .message {
            margin-bottom: 1rem;
            display: flex;
            gap: 0.75rem;
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
            width: 36px;
            height: 36px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.875rem;
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
            max-width: 70%;
            padding: 1rem;
            border-radius: 1rem;
            font-size: 0.95rem;
            line-height: 1.5;
        }

        .message.user .message-content {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #fff;
            border-bottom-right-radius: 0.25rem;
        }

        .message.assistant .message-content {
            background: #fff;
            border: 1px solid #e2e8f0;
            border-bottom-left-radius: 0.25rem;
        }

        .message-content img {
            max-width: 200px;
            border-radius: 0.5rem;
            margin-top: 0.5rem;
        }

        /* Chat Input */
        .chat-input {
            padding: 1.5rem;
            background: #fff;
            border-top: 1px solid #e2e8f0;
        }

        .input-container {
            display: flex;
            gap: 0.75rem;
            align-items: flex-end;
        }

        .input-wrapper {
            flex: 1;
            position: relative;
        }

        .chat-textarea {
            width: 100%;
            min-height: 44px;
            max-height: 120px;
            padding: 0.75rem 1rem;
            border: 2px solid #e2e8f0;
            border-radius: 1rem;
            font-size: 0.95rem;
            font-family: inherit;
            resize: none;
            outline: none;
            transition: border-color 0.2s;
        }

        .chat-textarea:focus {
            border-color: #667eea;
        }

        .send-btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #fff;
            border: none;
            border-radius: 1rem;
            padding: 0.75rem 1.5rem;
            font-size: 0.95rem;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .send-btn:hover {
            transform: translateY(-1px);
        }

        .send-btn:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
        }

        /* Upload Button */
        .upload-btn {
            background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
            color: #fff;
            border: none;
            border-radius: 1rem;
            padding: 0.75rem 1rem;
            font-size: 0.95rem;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            flex-shrink: 0;
        }

        .upload-btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(245, 158, 11, 0.4);
        }

        .upload-btn:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
        }

        /* Sidebar */
        .chat-sidebar {
            background: #fff;
            border-radius: 1rem;
            padding: 1.5rem;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            height: fit-content;
        }

        .sidebar-title {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 1rem;
            color: #1e293b;
        }

        .suggestion-card {
            background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
            border: 1px solid #e2e8f0;
            border-radius: 0.75rem;
            padding: 1rem;
            margin-bottom: 0.75rem;
            cursor: pointer;
            transition: all 0.2s;
        }

        .suggestion-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            border-color: #667eea;
        }

        .suggestion-card h4 {
            font-size: 0.95rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: #1e293b;
        }

        .suggestion-card p {
            font-size: 0.875rem;
            color: #64748b;
            line-height: 1.4;
        }

        /* Loading Animation */
        .typing-indicator {
            display: none;
            padding: 1rem;
            background: #fff;
            border: 1px solid #e2e8f0;
            border-radius: 1rem;
            margin-bottom: 1rem;
        }

        .typing-dots {
            display: flex;
            gap: 0.25rem;
            align-items: center;
        }

        .typing-dot {
            width: 8px;
            height: 8px;
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
                transform: translateY(-10px);
            }
        }

        /* Responsive */
        @media (max-width: 768px) {
            .chat-container {
                grid-template-columns: 1fr;
                gap: 1rem;
            }

            .chat-sidebar {
                order: -1;
            }

            .hero h1 {
                font-size: 2rem;
            }
        }

        /* Welcome Message */
        .welcome-message {
            text-align: center;
            padding: 2rem;
            color: #64748b;
        }

        .welcome-message h3 {
            color: #1e293b;
            margin-bottom: 0.5rem;
        }
    </style>
</head>
<body>
    <jsp:include page="/view/includes/navbar.jsp" />

    <div class="hero">
        <h1>Career Chatbot 🤖</h1>
        <p>Get personalized career advice, interview tips, and guidance from our AI assistant</p>
    </div>

    <div class="chat-container">
        <!-- Main Chat Area -->
        <div class="main-chat">
            <div class="chat-header">
                <div class="chat-avatar">
                    <i data-lucide="bot"></i>
                </div>
                <div class="chat-info">
                    <h3>Career Assistant</h3>
                    <p>AI-powered career guidance</p>
                </div>
            </div>

            <div class="chat-messages" id="chat-messages">
                <% if (chatHistory.isEmpty()) { %>
                    <div class="welcome-message">
                        <h3>👋 Welcome to Career Chatbot!</h3>
                        <p>I'm here to help you with career advice, interview preparation, and job search guidance. Ask me anything!</p>
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
                                    <img src="data:image/png;base64,<%= message.getBase64Image() %>" alt="Uploaded image">
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
                                placeholder="Ask me about career advice, interview tips, or job search strategies..."
                                rows="1"
                            ></textarea>
                        </div>
                        <button type="button" class="upload-btn" id="upload-btn" title="Upload image">
                            <i data-lucide="image"></i>
                        </button>
                        <input type="file" id="image-upload" accept="image/*" style="display: none;">
                        <button type="submit" class="send-btn" id="send-btn">
                            <i data-lucide="send"></i>
                            Send
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Sidebar -->
        <div class="chat-sidebar">
            <div class="sidebar-title">
                <i data-lucide="lightbulb"></i>
                Quick Suggestions
            </div>
            
            <div class="suggestion-card" onclick="sendSuggestion('How can I improve my resume?')">
                <h4>📝 Resume Tips</h4>
                <p>Get advice on writing a compelling resume that stands out to employers</p>
            </div>

            <div class="suggestion-card" onclick="sendSuggestion('What are common interview questions?')">
                <h4>🎤 Interview Prep</h4>
                <p>Learn about common interview questions and how to answer them effectively</p>
            </div>

            <div class="suggestion-card" onclick="sendSuggestion('How do I negotiate salary?')">
                <h4>💰 Salary Negotiation</h4>
                <p>Get tips on negotiating your salary and benefits package</p>
            </div>

            <div class="suggestion-card" onclick="sendSuggestion('What skills are in demand for IT jobs?')">
                <h4>🚀 Career Growth</h4>
                <p>Discover which skills are most valuable in the current IT job market</p>
            </div>

            <div class="suggestion-card" onclick="sendSuggestion('How do I handle job rejection?')">
                <h4>💪 Resilience</h4>
                <p>Learn how to stay motivated and bounce back from job rejections</p>
            </div>
        </div>
    </div>

    <script>
        lucide.createIcons();

        const chatMessages = document.getElementById('chat-messages');
        const chatForm = document.getElementById('chat-form');
        const userInput = document.getElementById('user-input');
        const sendBtn = document.getElementById('send-btn');
        const uploadBtn = document.getElementById('upload-btn');
        const imageUpload = document.getElementById('image-upload');
        const typingIndicator = document.getElementById('typing-indicator');

        // Auto-resize textarea
        userInput.addEventListener('input', function() {
            this.style.height = 'auto';
            this.style.height = Math.min(this.scrollHeight, 120) + 'px';
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

        // Send image message function
        function sendImageMessage(imageData) {
            // Add user image message
            const userMessage = createMessage('user', imageData);
            chatMessages.appendChild(userMessage);
            scrollToBottom();

            // Show typing indicator
            typingIndicator.style.display = 'block';
            scrollToBottom();

            // Send image to server
            const formData = new FormData();
            formData.append('image', dataURLtoBlob(imageData), 'image.jpg');
            formData.append('message', 'Image uploaded');

            fetch('ChatbotServlet', {
                method: 'POST',
                body: formData
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

        // Convert data URL to blob
        function dataURLtoBlob(dataURL) {
            const arr = dataURL.split(',');
            const mime = arr[0].match(/:(.*?);/)[1];
            const bstr = atob(arr[1]);
            let n = bstr.length;
            const u8arr = new Uint8Array(n);
            while (n--) {
                u8arr[n] = bstr.charCodeAt(n);
            }
            return new Blob([u8arr], { type: mime });
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
            
                         // Handle text content
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

        // Upload image button
        uploadBtn.addEventListener('click', function() {
            imageUpload.click();
        });

        // Handle image upload
        imageUpload.addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    const imageData = e.target.result;
                    sendImageMessage(imageData);
                };
                reader.readAsDataURL(file);
                imageUpload.value = ''; // Reset input
            }
        });

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
