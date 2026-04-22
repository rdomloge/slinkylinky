package com.domloge.slinkylinky.linkservice.controller;

import java.time.LocalDateTime;
import java.util.Optional;

import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.domloge.slinkylinky.events.AuditEvent;
import com.domloge.slinkylinky.linkservice.ai.ChatGpt;
import com.domloge.slinkylinky.linkservice.ai.ChatGptMessage;

import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping(".rest/aisupport")
@Slf4j
public class ChatGptController {

    @Autowired
    private ChatGpt chatGpt;

    @Autowired
    private AmqpTemplate auditRabbitTemplate;
    

    @PostMapping(path = "/generate", produces = "application/json")
    public @ResponseBody String generate(@RequestBody String prompt, @RequestHeader String user, @RequestHeader long proposalId) {
        log.info(user + " is generating a chatgpt response for prompt: " + prompt);

        // audit the usage of the AI
        AuditEvent auditEvent = new AuditEvent();
        auditEvent.setEventTime(LocalDateTime.now());
        auditEvent.setWho(user);
        auditEvent.setWhat("Use chatgpt");
        auditEvent.setDetail(prompt);
        auditEvent.setEntityId(String.valueOf(proposalId));
        auditEvent.setEntityType("Proposal");
        auditRabbitTemplate.convertAndSend(auditEvent);

        ChatGptMessage[] messages = {
            new ChatGptMessage("user", prompt)
        };
        Optional<String> reponse = chatGpt.queryChatGpt(messages);

        return reponse.orElse("No response from Chat GPT");
    }
}
