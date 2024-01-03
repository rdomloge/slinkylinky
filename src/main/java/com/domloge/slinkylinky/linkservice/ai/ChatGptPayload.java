package com.domloge.slinkylinky.linkservice.ai;

public class ChatGptPayload {
    private String model;
    private float temperature;
    private ChatGptMessage[] messages;
    
    public ChatGptPayload(String model, float temperature, ChatGptMessage[] messages) {
        this.model = model;
        this.temperature = temperature;
        this.messages = messages;
    }
}
