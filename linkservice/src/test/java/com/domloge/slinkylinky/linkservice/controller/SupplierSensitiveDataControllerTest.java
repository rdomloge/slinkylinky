package com.domloge.slinkylinky.linkservice.controller;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.util.List;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.test.web.servlet.MockMvc;

import com.domloge.slinkylinky.common.TenantTestHelper;
import com.domloge.slinkylinky.linkservice.entity.Supplier;
import com.domloge.slinkylinky.linkservice.repo.SupplierRepo;

/**
 * Wiring smoke test: confirms {@link com.domloge.slinkylinky.linkservice.config.SupplierSensitiveDataAdvice}
 * is registered in the MVC pipeline and masks {@code @GlobalAdminOnly} fields on the response.
 *
 * Per-shape masking correctness is covered by the unit tests on the masker and the advice;
 * this test only needs one endpoint to prove end-to-end wiring.
 */
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.MOCK)
@AutoConfigureMockMvc(addFilters = false)
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
public class SupplierSensitiveDataControllerTest {

    private static final String ORG = "00000000-0000-0000-0000-000000000001";

    @Autowired private MockMvc mockMvc;
    @Autowired private SupplierRepo supplierRepo;

    @MockBean(name = "auditRabbitTemplate")     private AmqpTemplate auditRabbitTemplate;
    @MockBean(name = "proposalsRabbitTemplate") private AmqpTemplate proposalsRabbitTemplate;
    @MockBean(name = "supplierRabbitTemplate")  private AmqpTemplate supplierRabbitTemplate;

    private Supplier saved;

    @BeforeEach
    void setUp() {
        SecurityContextHolder.clearContext();
        supplierRepo.deleteAll();
        TenantTestHelper.setSecurityContext("admin", ORG, List.of("global_admin"));

        saved = new Supplier();
        saved.setName("Secret Supplier");
        saved.setEmail("secret@supplier.com");
        saved.setSource("collaborator");
        saved.setDa(55);
        saved.setWebsite("https://www.secret.com");
        saved.setWeWriteFee(200);
        saved.setWeWriteFeeCurrency("GBP");
        supplierRepo.save(saved);
    }

    @AfterEach
    void tearDown() {
        supplierRepo.deleteAll();
        SecurityContextHolder.clearContext();
    }

    @Test
    void getSupplierById_globalAdmin_sensitiveFieldsPresent() throws Exception {
        TenantTestHelper.setSecurityContext("admin", ORG, List.of("global_admin"));

        mockMvc.perform(get("/.rest/supplierSupport/get").param("supplierId", String.valueOf(saved.getId())))
               .andExpect(status().isOk())
               .andExpect(jsonPath("$.name").value("Secret Supplier"))
               .andExpect(jsonPath("$.email").value("secret@supplier.com"))
               .andExpect(jsonPath("$.source").value("collaborator"))
               .andExpect(jsonPath("$.da").value(55));
    }

    @Test
    void getSupplierById_regularUser_sensitiveFieldsNulled() throws Exception {
        TenantTestHelper.setSecurityContext("user", ORG, List.of());

        mockMvc.perform(get("/.rest/supplierSupport/get").param("supplierId", String.valueOf(saved.getId())))
               .andExpect(status().isOk())
               .andExpect(jsonPath("$.name").doesNotExist())
               .andExpect(jsonPath("$.email").doesNotExist())
               .andExpect(jsonPath("$.source").doesNotExist())
               .andExpect(jsonPath("$.da").value(55))
               .andExpect(jsonPath("$.website").value("https://www.secret.com"));
    }
}
