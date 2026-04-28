package com.domloge.slinkylinky.userservice.dto;

import java.time.LocalDateTime;
import java.util.List;

public record UserOverviewDto(
    String userId,
    String email,
    String firstName,
    String lastName,
    boolean emailVerified,
    List<String> roles,
    LocalDateTime lastLogin
) {}
