package com.domloge.slinkylinky.linkservice.controller;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import com.domloge.slinkylinky.common.TenantContext;
import com.domloge.slinkylinky.common.TenantFilter;
import com.domloge.slinkylinky.linkservice.entity.Organisation;
import com.domloge.slinkylinky.linkservice.entity.audit.AuditRecord;
import com.domloge.slinkylinky.linkservice.repo.OrganisationRepo;
import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/.rest/organisations")
public class OrganisationController {

    @Autowired
    private OrganisationRepo organisationRepo;

    @Autowired
    private AmqpTemplate auditRabbitTemplate;

    /** List all organisations — global_admin only. */
    @GetMapping
    public ResponseEntity<Map<String, Object>> listAll() {
        TenantFilter.requireGlobalAdmin();
        List<Organisation> orgs = (List<Organisation>) organisationRepo.findAll();
        return ResponseEntity.ok(Map.of("_embedded", Map.of("organisations", orgs)));
    }

    /** Get a single organisation — global_admin or users belonging to that org. */
    @GetMapping("/{id}")
    public ResponseEntity<Organisation> getOne(@PathVariable UUID id) {
        Organisation org = organisationRepo.findById(id)
            .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));

        // global_admin can see any org; others can only see their own
        if (!TenantContext.isGlobalAdmin()) {
            String callerOrgId = TenantContext.getOrganisationId().orElse(null);
            if (!id.toString().equals(callerOrgId)) {
                throw new ResponseStatusException(HttpStatus.FORBIDDEN);
            }
        }
        return ResponseEntity.ok(org);
    }

    /** Create a new organisation — global_admin only. */
    @PostMapping
    public ResponseEntity<Organisation> create(@RequestBody Organisation body) {
        TenantFilter.requireGlobalAdmin();
        body.setId(UUID.randomUUID());
        body.setCreatedAt(LocalDateTime.now());
        Organisation saved = organisationRepo.save(body);
        log.info("Created organisation {}", saved.getId());

        AuditRecord ar = new AuditRecord();
        ar.setWho(TenantContext.getUsername());
        ar.setWhat("create organisation "+saved.getName());
        ar.setEventTime(LocalDateTime.now());
        ar.setEntityType("Organisation");
        ar.setDetail(saved.getName());
        TenantContext.getOrganisationId()
            .map(UUID::fromString)
            .ifPresent(ar::setOrganisationId);
        try {
            ObjectMapper mapper = new ObjectMapper();
            ar.setDetail(mapper.writeValueAsString(Map.of("id", saved.getId(), "name", saved.getName())));
        } catch (Exception e) {
            ar.setDetail("Id: " + saved.getId() + ", Name: " + saved.getName());
        }
        auditRabbitTemplate.convertAndSend(ar);

        return ResponseEntity.status(HttpStatus.CREATED).body(saved);
    }

    /** Update name / active flag — global_admin only. */
    @PatchMapping("/{id}")
    public ResponseEntity<Organisation> update(@PathVariable UUID id, @RequestBody Map<String, Object> patch) {
        TenantFilter.requireGlobalAdmin();
        Organisation org = organisationRepo.findById(id)
            .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));

        if (patch.containsKey("name")) org.setName((String) patch.get("name"));
        if (patch.containsKey("active")) org.setActive((Boolean) patch.get("active"));
        return ResponseEntity.ok(organisationRepo.save(org));
    }
}
