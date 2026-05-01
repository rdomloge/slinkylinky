package com.domloge.slinkylinky.linkservice.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Autowired
    private GlobalAdminProjectionInterceptor globalAdminProjectionInterceptor;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(globalAdminProjectionInterceptor)
                .addPathPatterns("/.rest/suppliers", "/.rest/suppliers/**");
    }
}
