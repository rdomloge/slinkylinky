package com.domloge.slinkylinky.linkservice.ai;

public class ChatGptMessage {

    private String role;
    private String content;
    
    public ChatGptMessage(String role, String content) {
        this.role = role;
        this.content = content;
    }
}
