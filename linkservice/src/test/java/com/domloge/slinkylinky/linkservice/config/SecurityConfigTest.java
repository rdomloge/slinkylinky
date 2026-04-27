package com.domloge.slinkylinky.linkservice.config;

import static org.junit.jupiter.api.Assertions.assertNotEquals;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.junit.jupiter.api.Test;
import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.test.web.servlet.MockMvc;

/**
 * Verifies that the security filter chain correctly permits public endpoints
 * and protects secured ones. Uses MockMvc so requests pass through the full
 * Spring Security filter chain (unlike ProposalSupportControllerTest which
 * calls the controller directly and bypasses security entirely).
 */
@SpringBootTest
@AutoConfigureMockMvc
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
public class SecurityConfigTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean(name = "auditRabbitTemplate")
    private AmqpTemplate auditRabbitTemplate;

    @MockBean(name = "proposalsRabbitTemplate")
    private AmqpTemplate proposalsRabbitTemplate;

    @MockBean(name = "supplierRabbitTemplate")
    private AmqpTemplate supplierRabbitTemplate;

    @Test
    void getArticleFormatted_isPublic() throws Exception {
        // Two valid success paths — both prove security did not block the request:
        //   1. The controller returns a response (any non-401 status is fine; 500 is expected
        //      because proposal 99999 does not exist but no custom exception handler maps it).
        //   2. The controller throws NoSuchElementException, which MockMvc wraps in a
        //      ServletException chain. Catching it here confirms the request reached the
        //      controller; security blocks produce a committed response, not a Java exception.
        try {
            mockMvc.perform(get("/.rest/proposalsupport/getArticleFormatted")
                    .param("proposalId", "99999"))
                   .andExpect(result -> assertNotEquals(
                           401,
                           result.getResponse().getStatus(),
                           "getArticleFormatted is a public endpoint and must not require authentication"));
        } catch (Exception e) {
            Throwable cause = e;
            while (cause != null) {
                if (cause instanceof java.util.NoSuchElementException) {
                    return; // request reached the controller — security passed it through
                }
                cause = cause.getCause();
            }
            throw e;
        }
    }

    @Test
    void errorEndpoint_isPublic() throws Exception {
        // /error must be accessible without a token. Spring Boot dispatches to /error
        // when a controller throws; if /error is security-blocked, the real error detail
        // is swallowed and replaced by a bare security response.
        //
        // Assert neither 401 (Spring Security auth entry point) nor 403
        // (EmailVerifiedFilter) is returned, so accidental removal of /error from
        // either whitelist is caught.
        mockMvc.perform(get("/error"))
               .andExpect(result -> {
                   int status = result.getResponse().getStatus();
                   assertNotEquals(401, status, "/error must not require authentication");
                   assertNotEquals(403, status, "/error must not be blocked by EmailVerifiedFilter");
               });
    }

    @Test
    void securedEndpoint_requiresAuth() throws Exception {
        // Confirms the security filter chain IS active and blocking unauthenticated
        // requests on non-whitelisted endpoints.
        //
        // The response is either 401 (Unauthorized, from Spring Security's
        // AuthenticationEntryPoint) or 403 (Forbidden, from EmailVerifiedFilter)
        // depending on filter execution order in the Spring context. Both indicate
        // the request was correctly blocked. We accept either status.
        mockMvc.perform(get("/.rest/suppliers"))
               .andExpect(result -> {
                   int status = result.getResponse().getStatus();
                   if (status != 401 && status != 403) {
                       throw new AssertionError(
                           "Protected endpoint must return 401 or 403, got " + status);
                   }
               });
    }

    @Test
    void actuatorHealth_isPublic() throws Exception {
        // /actuator/** is exempt from both Spring Security auth and EmailVerifiedFilter
        // so that infrastructure health probes work without a JWT.
        //
        // The test context uses Spring Boot's default actuator exposure, which includes
        // /actuator/health. Exact status depends on the H2-backed health state (200 or 503).
        mockMvc.perform(get("/actuator/health"))
               .andExpect(result -> {
                   int status = result.getResponse().getStatus();
                   assertNotEquals(401, status, "/actuator/health must not require authentication");
                   assertNotEquals(403, status, "/actuator/health must not be blocked by EmailVerifiedFilter");
               });
    }
}
