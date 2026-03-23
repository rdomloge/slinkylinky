package com.domloge.slinkylinky.woocommerce.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.data.rest.core.config.RepositoryRestConfiguration;
import org.springframework.data.rest.webmvc.config.RepositoryRestConfigurer;
import org.springframework.web.servlet.config.annotation.CorsRegistry;

import com.domloge.slinkylinky.woocommerce.entity.LightOrderProjection;
import com.domloge.slinkylinky.woocommerce.entity.OrderEntity;

@Configuration
public class RestConfig implements RepositoryRestConfigurer {
 
    @Override
    public void configureRepositoryRestConfiguration(RepositoryRestConfiguration config, CorsRegistry cors) {
        
        config.getProjectionConfiguration()
            .addProjection(LightOrderProjection.class);
        
        config.exposeIdsFor(
          OrderEntity.class, 
          LightOrderProjection.class);
    }
}
