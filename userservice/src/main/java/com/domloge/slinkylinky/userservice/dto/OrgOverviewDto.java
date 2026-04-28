package com.domloge.slinkylinky.userservice.dto;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

public record OrgOverviewDto(
    UUID orgId,
    String orgName,
    String orgSlug,
    LocalDateTime createdAt,
    List<UserOverviewDto> users
) {}
