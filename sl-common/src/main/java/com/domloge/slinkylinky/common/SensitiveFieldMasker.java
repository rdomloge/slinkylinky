package com.domloge.slinkylinky.common;

import java.lang.reflect.Field;

/**
 * Nulls out fields annotated with {@link GlobalAdminOnly} for any caller that is not a global_admin.
 * Safe to call in the HTTP response path; does not affect persisted state.
 */
public class SensitiveFieldMasker {

    private SensitiveFieldMasker() {}

    /**
     * Nulls all {@link GlobalAdminOnly}-annotated fields on {@code entity} when the current caller
     * is not a global_admin. Returns the (possibly modified) entity for chaining.
     */
    public static <T> T mask(T entity) {
        if (entity == null || TenantContext.isGlobalAdmin()) return entity;
        Class<?> clazz = entity.getClass();
        while (clazz != null && clazz != Object.class) {
            for (Field field : clazz.getDeclaredFields()) {
                if (field.isAnnotationPresent(GlobalAdminOnly.class)) {
                    field.setAccessible(true);
                    try {
                        field.set(entity, null);
                    } catch (IllegalAccessException ignored) {}
                }
            }
            clazz = clazz.getSuperclass();
        }
        return entity;
    }
}
