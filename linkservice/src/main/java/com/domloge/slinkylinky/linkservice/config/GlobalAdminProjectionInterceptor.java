package com.domloge.slinkylinky.linkservice.config;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.servlet.HandlerInterceptor;

import com.domloge.slinkylinky.common.TenantContext;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Blocks non-global_admin callers from requesting the globalAdminSupplier projection,
 * which exposes sensitive supplier fields (email, source).
 */
@Component
public class GlobalAdminProjectionInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
        String projection = request.getParameter("projection");
        if ("globalAdminSupplier".equals(projection) && !TenantContext.isGlobalAdmin()) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN,
                    "globalAdminSupplier projection requires global_admin role");
        }
        return true;
    }
}
