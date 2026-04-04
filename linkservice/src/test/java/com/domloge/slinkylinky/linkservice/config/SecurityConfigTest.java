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
        // Spring Security must not block this with 401.
        // Proposal 99999 won't exist in H2, so the controller will throw
        // NoSuchElementException once it reaches the DB — that's fine.
        // Any exception propagating out of the controller proves the request
        // passed through the security filter chain (Spring Security returns a
        // 401 response directly, it does not throw a servlet exception).
        try {
            mockMvc.perform(get("/.rest/proposalsupport/getArticleFormatted")
                    .param("proposalId", "99999"))
                   .andExpect(result -> assertNotEquals(
                           401,
                           result.getResponse().getStatus(),
                           "getArticleFormatted is a public endpoint and must not require authentication"));
        } catch (Exception e) {
            if (e.getCause() instanceof java.util.NoSuchElementException) {
                // Request passed Spring Security and reached the controller.
                // Controller threw because proposal 99999 does not exist — expected.
                return;
            }
            throw e;
        }
    }

    @Test
    void securedEndpoint_requiresAuth() throws Exception {
        // Confirms the security filter IS active and enforcing auth on protected endpoints
        mockMvc.perform(get("/.rest/suppliers"))
               .andExpect(status().isUnauthorized());
    }
}
