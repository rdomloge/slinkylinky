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

import com.domloge.slinkylinky.linkservice.ai.ChatGpt;
import com.domloge.slinkylinky.linkservice.ai.ChatGptMessage;
import com.domloge.slinkylinky.linkservice.entity.audit.AuditRecord;

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
        AuditRecord auditRecord = new AuditRecord();
        auditRecord.setEventTime(LocalDateTime.now());
        auditRecord.setWho(user);
        auditRecord.setWhat("Use chatgpt");
        auditRecord.setDetail(prompt);
        auditRecord.setEntityId(proposalId);
        auditRecord.setEntityType("Proposal");
        auditRabbitTemplate.convertAndSend(auditRecord);

        ChatGptMessage[] messages = {
            new ChatGptMessage("user", prompt)
        };
        Optional<String> reponse = chatGpt.queryChatGpt(messages);

        return reponse.orElse("No response from Chat GPT");
    }
}
