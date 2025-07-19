<%@ page import="java.util.List" %>
<%@ page import="model.Message" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<%
    List<Message> chatHistory = (List<Message>) session.getAttribute("chatHistory");
    if (chatHistory == null) {
        chatHistory = new java.util.ArrayList<>();
    }
%>
<div class="chat2-wrapper">
    <style>
        .chat2-wrapper {
            /* Scope all chat styles to this wrapper */
        }

        .chat2-wrapper html, .chat2-wrapper body {
            height: 100%;
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Arial, sans-serif;
            background: linear-gradient(120deg, #e0eafc 0%, #cfdef3 100%);
        }
        .chat2-wrapper #main-chat-container {
            min-height: 100vh;
            min-width: 100vw;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            margin: 0;
            padding: 0;
        }
        .chat2-wrapper #chat2-box {
            width: 97vw;
            height: 94vh;
            background: #fff;
            border-radius: 18px;
            box-shadow: 0 8px 32px rgba(44,62,80,0.18);
            display: flex;
            flex-direction: column;
            overflow: hidden;
            margin: 1vh auto;
        }
        .chat2-wrapper #chat2-header {
            background: #6a82fb;
            color: #fff;
            padding: 22px 24px;
            font-size: 26px;
            font-weight: bold;
            border-radius: 18px 18px 0 0;
            letter-spacing: 1px;
            position: relative;
        }
        .chat2-wrapper #voice-indicator {
            position: absolute;
            right: 20px;
            top: 20px;
            background: #ff5252;
            color: #fff;
            padding: 3px 10px;
            border-radius: 8px;
            font-size: 13px;
            font-weight: bold;
            display: none;
            z-index: 10;
        }
        .chat2-wrapper #chat2-messages {
            flex: 1;
            padding: 24px;
            overflow-y: auto;
            background: #f4f7fa;
        }
        .chat2-wrapper #chat2-messages ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .chat2-wrapper #chat2-messages li {
            margin-bottom: 16px;
            padding: 12px 18px;
            border-radius: 10px;
            width: 100%;
            word-break: break-word;
            font-size: 16px;
            box-sizing: border-box;
            animation: chat-fade-in 0.35s ease;
        }
        @keyframes chat-fade-in {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        .chat2-wrapper #chat2-messages li.user {
            background: #e3f2fd;
            align-self: flex-end;
            text-align: right;
            width: 100%;
        }
        .chat2-wrapper #chat2-messages li.assistant {
            background: #ede7f6;
            align-self: flex-start;
            text-align: left;
            width: 100%;
        }
        .chat2-wrapper #chat2-form {
            display: flex;
            flex-direction: column;
            border-top: 1px solid #e0e0e0;
            padding: 18px 24px;
            background: #fafbfc;
            gap: 10px;
        }
        .chat2-wrapper #chat2-form-row {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .chat2-wrapper #chat2-form input[type="text"] {
            flex: 1;
            padding: 12px;
            border: 1px solid #bdbdbd;
            border-radius: 8px;
            font-size: 16px;
        }
        .chat2-wrapper #chat2-form button,
        .chat2-wrapper #chat2-form .image-upload-btn {
            padding: 12px 20px;
            background: #6a82fb;
            color: #fff;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
            font-weight: bold;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 44px;
        }
        .chat2-wrapper #chat2-form button:hover,
        .chat2-wrapper #chat2-form .image-upload-btn:hover {
            background: #4e54c8;
        }
        .chat2-wrapper #chat2-form .image-upload-btn {
            width: 44px;
            min-width: 44px;
            padding: 0;
        }
        .chat2-wrapper #chat2-form input[type="file"] {
            display: none;
        }
        .chat2-wrapper #chat2-image-preview {
            display: none;
            position: relative;
            width: fit-content;
        }
        .chat2-wrapper #chat2-image-preview img {
            max-width: 160px;
            max-height: 160px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(44,62,80,0.12);
            display: block;
        }
        .chat2-wrapper #chat2-image-preview .remove-preview {
            position: absolute;
            top: -6px;
            right: -6px;
            background: #ff5252;
            color: #fff;
            border: none;
            border-radius: 50%;
            width: 22px;
            height: 22px;
            font-size: 14px;
            line-height: 20px;
            text-align: center;
            cursor: pointer;
            font-weight: bold;
            box-shadow: 0 0 4px rgba(0,0,0,0.2);
        }
        .chat2-wrapper .chat-image {
            max-width: 180px;
            max-height: 180px;
            border-radius: 10px;
            margin-top: 6px;
            display: block;
            animation: img-scale-in 0.4s cubic-bezier(.4,2,.6,1) 1;
        }
        @keyframes img-scale-in {
            from {
                opacity: 0;
                transform: scale(0.85);
            }
            to {
                opacity: 1;
                transform: scale(1);
            }
        }
        .chat2-wrapper #chat2-messages li.user .chat-image {
            margin-left: auto;
            margin-right: 0;
            display: block;
        }
        .chat2-wrapper #chat2-nav {
            text-align: center;
            margin: 18px 0 0 0;
        }
        .chat2-wrapper #chat2-nav a {
            color: #6a82fb;
            text-decoration: none;
            font-size: 15px;
        }
        .chat2-wrapper #chat2-nav a:hover {
            text-decoration: underline;
        }
        .chat2-wrapper #chat2-footer {
            text-align: center;
            padding: 10px;
            font-size: 13px;
            color: #aaa;
        }
        .chat2-wrapper .pre-question-btn {
            margin: 4px 8px;
            padding: 10px 20px;
            background: #e3f2fd;
            border: 1px solid #6a82fb;
            border-radius: 8px;
            color: #333;
            font-size: 16px;
            cursor: pointer;
            transition: background 0.2s;
        }
        .chat2-wrapper .pre-question-btn:hover {
            background: #bbdefb;
        }
    </style>

    <div id="main-chat-container">
        <div id="chat2-box">
            <div id="chat2-header">Chatbot Interface 2
                <span id="voice-indicator">? Voice</span>
            </div>
            <% if (chatHistory.isEmpty()) { %>
            <div id="pre-questions" style="padding:18px;text-align:center;">
                <div style="margin-bottom:10px;font-weight:bold;">Bạn có thể thử hỏi:</div>
                <button class="pre-question-btn" onclick="sendPreQuestion('Giải thích REST API là gì?')">REST API là gì?</button>
                <button class="pre-question-btn" onclick="sendPreQuestion('Gợi ý lộ trình học lập trình Backend')">Lộ trình Backend?</button>
                <button class="pre-question-btn" onclick="sendPreQuestion('Tôi nên học gì để trở thành Fullstack Developer?')">Học để làm Fullstack?</button>
                <button class="pre-question-btn" onclick="sendPreQuestion('Cho tôi ví dụ truy vấn SQL cơ bản')">Truy vấn SQL?</button>
            </div>

            <% } %>
            <div id="chat2-messages">
                <ul>
                    <% for (Message msg : chatHistory) {%>
                    <li class="<%= msg.getRole()%>">
                        <b><%= msg.getRole()%>:</b> <span class="markdown-body" data-raw="<%= msg.getText().replace("\"", "&quot;").replace("'", "&#39;")%>"></span>
                        <% if (msg.getBase64Image() != null) {%>
                        <br><img class="chat-image" src="data:image/png;base64,<%= msg.getBase64Image()%>" />
                            <% } %>
                    </li>
                    <% }%>
                </ul>
            </div>
            <form id="chat2-form" method="post" action="chat" enctype="multipart/form-data">
                <div id="chat2-image-preview">
                    <img id="chat2-preview-img" src="" alt="Preview" />
                    <button type="button" class="remove-preview" onclick="removeImagePreview()">Ã</button>
                </div>
                <div id="chat2-form-row">
                    <input type="text" name="message" placeholder="Type your message..." />
                    <button type="button" class="image-upload-btn" title="Upload image" onclick="document.getElementById('image-upload').click();">
                        <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect>
                            <circle cx="8.5" cy="8.5" r="1.5"></circle>
                            <polyline points="21 15 16 10 5 21"></polyline>
                        </svg>
                    </button>
                    <input id="image-upload" type="file" name="imageFile" accept="image/*" />
                    <button type="submit">Send</button>
                </div>
            </form>
        </div>
        <div id="chat2-nav">
            <a href="chat1.jsp">Go to Chat 1</a>
        </div>
        <div id="chat2-footer">&copy; Cursor Chat</div>
    </div>

    <script>
        let recognizing = false;
        let recognition;
        let voiceTimeout;

        function toggleVoice() {
            if (!('webkitSpeechRecognition' in window) && !('SpeechRecognition' in window)) {
                alert('Your browser does not support Speech Recognition.');
                return;
            }
            if (recognizing) {
                stopVoice();
            } else {
                startVoice();
            }
        }

        function startVoice() {
            const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
            if (!recognition) {
                recognition = new SpeechRecognition();
                recognition.lang = 'en-US';
                recognition.interimResults = true;
                recognition.continuous = true;
                recognition.onresult = function (event) {
                    let transcript = '';
                    for (let i = event.resultIndex; i < event.results.length; ++i) {
                        transcript += event.results[i][0].transcript;
                    }
                    document.querySelector('#chat2-form input[name="message"]').value = transcript;
                    resetVoiceTimeout();
                };
                recognition.onend = function () {
                    stopVoice();
                };
            }
            recognizing = true;
            document.getElementById('voice-indicator').style.display = 'inline-block';
            recognition.start();
            resetVoiceTimeout();
        }

        function stopVoice() {
            recognizing = false;
            if (recognition)
                recognition.stop();
            document.getElementById('voice-indicator').style.display = 'none';
            clearTimeout(voiceTimeout);
        }

        function resetVoiceTimeout() {
            clearTimeout(voiceTimeout);
            voiceTimeout = setTimeout(stopVoice, 2000);
        }

        document.addEventListener('keydown', function (e) {
            if (e.key === 'v' || e.key === 'V') {
                e.preventDefault();
                toggleVoice();
            }
        });

        function renderMessages(messages) {
            const ul = document.querySelector('#chat2-messages ul');
            ul.innerHTML = '';
            messages.forEach(function (msg) {
                const li = document.createElement('li');
                li.className = msg.role;
                li.innerHTML = '<b>' + msg.role + ':</b> <span class="markdown-body">' + (msg.text ? marked.parse(msg.text) : '') + '</span>';
                if (msg.base64Image) {
                    li.innerHTML += '<br><img class="chat-image" src="data:image/png;base64,' + msg.base64Image + '"/>';
                }
                ul.appendChild(li);
            });
            scrollToBottom();
        }

        function setLoading(loading) {
            let loadingDiv = document.getElementById('chat2-loading');
            if (!loadingDiv) {
                loadingDiv = document.createElement('div');
                loadingDiv.id = 'chat2-loading';
                loadingDiv.style.textAlign = 'center';
                loadingDiv.style.color = '#aaa';
                loadingDiv.style.fontSize = '13px';
                loadingDiv.innerText = 'Thinking...';
                document.getElementById('chat2-messages').appendChild(loadingDiv);
            }
            loadingDiv.style.display = loading ? 'block' : 'none';
        }

        function sendMessageAjax(e) {
            e.preventDefault();
            const input = document.querySelector('#chat2-form input[name="message"]');
            const fileInput = document.querySelector('#chat2-form input[type="file"]');
            const message = input.value.trim();
            const file = fileInput.files[0];

            if (!message && !file)
                return;

            const ul = document.querySelector('#chat2-messages ul');
            const li = document.createElement('li');
            li.className = 'user';
            li.innerHTML = '<b>user:</b> ' + (message ? message : '');

            if (file) {
                const reader = new FileReader();
                reader.onload = function (evt) {
                    const base64 = evt.target.result.split(',')[1];
                    li.innerHTML += '<br><img class="chat-image" src="data:image/png;base64,' + base64 + '"/>';
                    ul.appendChild(li);
                    scrollToBottom();
                };
                reader.readAsDataURL(file);
            } else {
                ul.appendChild(li);
                scrollToBottom();
            }

            const formData = new FormData();
            formData.append("message", message);
            formData.append("fromPage", "chat2.jsp");
            formData.append("ajax", "1");
            if (file) {
                formData.append("imageFile", file);
            }

            input.value = '';
            fileInput.value = '';
            input.focus();
            setLoading(true);

            fetch('ChatbotServlet', {
                method: 'POST',
                body: formData
            })
                    .then(res => res.json())
                    .then(data => {
                        setLoading(false);
                        if (data && data.chatHistory) {
                            renderMessages(data.chatHistory);
                        }
                    })
                    .catch(() => {
                        setLoading(false);
                        alert('Error sending message.');
                    });
        }

        function scrollToBottom() {
            const container = document.getElementById('chat2-messages');
            container.scrollTop = container.scrollHeight;
        }

        function removeImagePreview() {
            document.getElementById('image-upload').value = '';
            document.getElementById('chat2-image-preview').style.display = 'none';
            document.getElementById('chat2-preview-img').src = '';
        }

        function sendPreQuestion(text) {
            const input = document.querySelector('#chat2-form input[name="message"]');
            input.value = text;
            document.getElementById('chat2-form').dispatchEvent(new Event('submit', {cancelable: true, bubbles: true}));
        }

        window.onload = function () {
            document.getElementById('chat2-form').onsubmit = sendMessageAjax;

            document.getElementById('image-upload').addEventListener('change', function (e) {
                const file = e.target.files[0];
                const previewDiv = document.getElementById('chat2-image-preview');
                const previewImg = document.getElementById('chat2-preview-img');
                if (file) {
                    const reader = new FileReader();
                    reader.onload = function (evt) {
                        previewImg.src = evt.target.result;
                        previewDiv.style.display = 'block';
                    };
                    reader.readAsDataURL(file);
                } else {
                    previewDiv.style.display = 'none';
                    previewImg.src = '';
                }
            });

            document.getElementById('chat2-form').addEventListener('submit', function () {
                removeImagePreview();
            });
        };

        // Render markdown for initial messages from data-raw
        window.addEventListener('DOMContentLoaded', function () {
            document.querySelectorAll('.markdown-body').forEach(function (el) {
                const raw = el.getAttribute('data-raw');
                if (raw)
                    el.innerHTML = marked.parse(raw);
            });
        });
    </script>
</div>
