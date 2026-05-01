package com.domloge.slinkylinky.linkservice.config;

import org.springframework.data.domain.Page;
import org.springframework.hateoas.CollectionModel;
import org.springframework.hateoas.EntityModel;
import org.springframework.hateoas.PagedModel;
import org.springframework.http.MediaType;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.servlet.mvc.method.annotation.ResponseBodyAdvice;
import org.springframework.core.MethodParameter;

import com.domloge.slinkylinky.common.SensitiveFieldMasker;
import com.domloge.slinkylinky.common.TenantContext;
import com.domloge.slinkylinky.linkservice.entity.Supplier;

/**
 * Strips {@link com.domloge.slinkylinky.common.GlobalAdminOnly} fields from all Supplier
 * responses for callers that are not global_admin.
 *
 * Covers direct entity responses (Spring Data REST without projection) and all controller
 * endpoints that return Supplier or collections of Supplier.
 * Projection-based access is enforced separately via the projection definitions and
 * {@link GlobalAdminProjectionInterceptor}.
 */
@ControllerAdvice
public class SupplierSensitiveDataAdvice implements ResponseBodyAdvice<Object> {

    @Override
    public boolean supports(MethodParameter returnType, Class<? extends HttpMessageConverter<?>> converterType) {
        return MappingJackson2HttpMessageConverter.class.isAssignableFrom(converterType);
    }

    @Override
    public Object beforeBodyWrite(Object body, MethodParameter returnType, MediaType selectedContentType,
            Class<? extends HttpMessageConverter<?>> selectedConverterType,
            ServerHttpRequest request, ServerHttpResponse response) {

        if (body == null || TenantContext.isGlobalAdmin()) return body;

        if (body instanceof Supplier s) {
            SensitiveFieldMasker.mask(s);
        } else if (body instanceof Supplier[] arr) {
            for (Supplier s : arr) SensitiveFieldMasker.mask(s);
        } else if (body instanceof Page<?> page) {
            page.getContent().stream()
                .filter(Supplier.class::isInstance)
                .map(Supplier.class::cast)
                .forEach(SensitiveFieldMasker::mask);
        } else if (body instanceof EntityModel<?> em && em.getContent() instanceof Supplier s) {
            SensitiveFieldMasker.mask(s);
        } else if (body instanceof PagedModel<?> pm) {
            maskCollectionItems(pm);
        } else if (body instanceof CollectionModel<?> cm) {
            maskCollectionItems(cm);
        }

        return body;
    }

    private void maskCollectionItems(CollectionModel<?> model) {
        model.getContent().forEach(item -> {
            if (item instanceof EntityModel<?> em && em.getContent() instanceof Supplier s) {
                SensitiveFieldMasker.mask(s);
            }
        });
    }
}
