package com.domloge.slinkylinky.supplierengagement.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.domloge.slinkylinky.supplierengagement.entity.CollaboratorCategoryMapping;
import com.domloge.slinkylinky.supplierengagement.entity.MappingStatus;
import com.domloge.slinkylinky.supplierengagement.repo.CollaboratorCategoryMappingRepo;

@RestController
@RequestMapping("/.rest/engagements/category-mappings")
@PreAuthorize("hasRole('global_admin')")
public class CategoryMappingController {

    @Autowired
    private CollaboratorCategoryMappingRepo mappingRepo;

    /** Returns all category mappings ordered by status then name. */
    @GetMapping
    public List<CollaboratorCategoryMapping> listAll() {
        return mappingRepo.findAllByOrderByStatusAscCollaboratorCategoryAsc();
    }

    /** Returns only PENDING mappings (categories that need to be resolved). */
    @GetMapping("/pending")
    public List<CollaboratorCategoryMapping> listPending() {
        return mappingRepo.findAllByStatus(MappingStatus.PENDING);
    }

    /**
     * Maps a Collaborator category to a SlinkyLinky category.
     * Body: { "slCategoryId": 42, "slCategoryName": "Technology" }
     */
    @PostMapping("/{id}/map")
    public ResponseEntity<CollaboratorCategoryMapping> map(
            @PathVariable long id,
            @RequestBody Map<String, Object> body) {

        CollaboratorCategoryMapping mapping = mappingRepo.findById(id).orElse(null);
        if (mapping == null) return ResponseEntity.notFound().build();

        Object idObj = body.get("slCategoryId");
        String name  = (String) body.get("slCategoryName");
        if (idObj == null || name == null || name.isBlank()) {
            return ResponseEntity.badRequest().build();
        }

        long slCategoryId = ((Number) idObj).longValue();
        mapping.setSlCategoryId(slCategoryId);
        mapping.setSlCategoryName(name.trim());
        mapping.setStatus(MappingStatus.MAPPED);
        return ResponseEntity.ok(mappingRepo.save(mapping));
    }

    /** Marks a Collaborator category as intentionally ignored (will not block lead actions). */
    @PostMapping("/{id}/ignore")
    public ResponseEntity<CollaboratorCategoryMapping> ignore(@PathVariable long id) {
        CollaboratorCategoryMapping mapping = mappingRepo.findById(id).orElse(null);
        if (mapping == null) return ResponseEntity.notFound().build();

        mapping.setSlCategoryId(null);
        mapping.setSlCategoryName(null);
        mapping.setStatus(MappingStatus.IGNORED);
        return ResponseEntity.ok(mappingRepo.save(mapping));
    }

    /**
     * Resolves a batch of category mappings in a single request. Each entry specifies
     * the raw Collaborator category name, the action (MAP or IGNORE), and — for MAP —
     * the target SL category id and name. Rows are created if they don't exist yet
     * (upsert), so this works whether or not the scraper has previously populated the
     * table.
     *
     * <p>Request body: [{collaboratorCategory, action, slCategoryId?, slCategoryName?}]</p>
     */
    @PostMapping("/resolve")
    public ResponseEntity<List<CollaboratorCategoryMapping>> resolve(
            @RequestBody List<Map<String, Object>> resolutions) {

        List<CollaboratorCategoryMapping> results = new ArrayList<>();
        for (Map<String, Object> entry : resolutions) {
            String cat    = (String) entry.get("collaboratorCategory");
            String action = (String) entry.get("action");
            if (cat == null || cat.isBlank() || action == null) continue;

            CollaboratorCategoryMapping mapping = mappingRepo
                    .findByCollaboratorCategory(cat)
                    .orElseGet(() -> {
                        CollaboratorCategoryMapping m = new CollaboratorCategoryMapping();
                        m.setCollaboratorCategory(cat);
                        return m;
                    });

            if ("IGNORE".equalsIgnoreCase(action)) {
                mapping.setSlCategoryId(null);
                mapping.setSlCategoryName(null);
                mapping.setStatus(MappingStatus.IGNORED);
            } else {
                Object idObj = entry.get("slCategoryId");
                String name  = (String) entry.get("slCategoryName");
                if (idObj == null || name == null || name.isBlank()) continue;
                mapping.setSlCategoryId(((Number) idObj).longValue());
                mapping.setSlCategoryName(name.trim());
                mapping.setStatus(MappingStatus.MAPPED);
            }
            results.add(mappingRepo.save(mapping));
        }
        return ResponseEntity.ok(results);
    }

    /**
     * Deletes a mapping entirely. The next scrape will re-create it as PENDING
     * if the category is still seen in Collaborator.
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable long id) {
        if (!mappingRepo.existsById(id)) return ResponseEntity.notFound().build();
        mappingRepo.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}
