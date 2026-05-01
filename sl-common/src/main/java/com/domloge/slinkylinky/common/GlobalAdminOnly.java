package com.domloge.slinkylinky.common;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Marks a field that must only appear in API responses for global_admin callers.
 * Apply {@link SensitiveFieldMasker#mask} to any object before serialisation to enforce this.
 */
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.FIELD)
public @interface GlobalAdminOnly {}
