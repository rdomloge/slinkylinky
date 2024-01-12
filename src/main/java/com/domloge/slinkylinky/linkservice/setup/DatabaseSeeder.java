package com.domloge.slinkylinky.linkservice.setup;

import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedList;
import java.util.List;
import java.util.Random;
import java.util.concurrent.ThreadLocalRandom;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;

import com.domloge.slinkylinky.linkservice.entity.Category;
import com.domloge.slinkylinky.linkservice.entity.Demand;
import com.domloge.slinkylinky.linkservice.entity.DemandSite;
import com.domloge.slinkylinky.linkservice.entity.PaidLink;
import com.domloge.slinkylinky.linkservice.entity.Proposal;
import com.domloge.slinkylinky.linkservice.entity.Supplier;
import com.domloge.slinkylinky.linkservice.repo.CategoryRepo;
import com.domloge.slinkylinky.linkservice.repo.DemandRepo;
import com.domloge.slinkylinky.linkservice.repo.DemandSiteRepo;
import com.domloge.slinkylinky.linkservice.repo.PaidLinkRepo;
import com.domloge.slinkylinky.linkservice.repo.ProposalRepo;
import com.domloge.slinkylinky.linkservice.repo.SupplierRepo;

import jakarta.annotation.PostConstruct;
import jakarta.transaction.Transactional;
import lombok.extern.slf4j.Slf4j;

// @Service
@Slf4j
public class DatabaseSeeder {
    
    private Random random = new Random();
    
    @Autowired
    private SupplierRepo supplierRepo;
    
    @Autowired
    private DemandSiteRepo demandSiteRepo;

    @Autowired
    private DemandRepo demandRepo;

    @Autowired
    private ProposalRepo proposalRepo;

    @Autowired
    private PaidLinkRepo paidLinkRepo;

    @Autowired
    private CategoryRepo categoryRepo;

    @Transactional
    @PostConstruct
    public void seedDatabase() {
        log.info("Seeding database");
        log.debug("Creating suppliers");
        LinkedList<Supplier> temp = new LinkedList<>();
        for (int i = 0; i < 10000; i++) {
            Supplier supplier = createTestSupplier(i);
            Supplier saved = supplierRepo.save(supplier);
            temp.add(saved);
            if(i % 1000 == 0) {
                log.debug("Created {} suppliers", i);
            }
        }
        Supplier[] suppliers = temp.toArray(new Supplier[0]);

        log.debug("Creating demand sites");
        for (int i = 0; i < 20000; i++) {
            DemandSite demandSite = createTestDemandSite(i);
            demandSiteRepo.save(demandSite);
            if(i % 1000 == 0) {
                log.debug("Created {} demand sites", i);
            }
        }

        log.debug("Creating proposals");
        for (int i = 0; i < 30000; i++) {
            List<Demand> demands = new ArrayList<>();
            for (int j = 0; j < random.nextInt(1,3); j++) {
                Demand demand = createTestDemand(i);
                demands.add(demandRepo.save(demand));
            }

            Proposal proposal = createTestProposal(i);

            List<PaidLink> pls = 
                demands.stream().map(demand -> {
                    PaidLink paidLink = new PaidLink();
                    paidLink.setDemand(demand);
                    paidLink.setSupplier(suppliers[random.nextInt(suppliers.length)]);
                    paidLinkRepo.save(paidLink);
                    return paidLink;
            })
            .collect(Collectors.toList());

            proposal.setPaidLinks(pls);

            proposalRepo.save(proposal);

            if(i % 1000 == 0) {
                log.debug("Created {} proposals", i);
            }
        }
    }

    private Proposal createTestProposal(int seed) {
        String[] blogTitles = {
            "10 Tips for Effective Time Management",
            "How to Boost Your Productivity at Work",
            "The Ultimate Guide to Healthy Eating",
            "Exploring the Benefits of Meditation",
            "5 Must-Visit Destinations for Your Next Vacation",
            "The Future of Technology: Trends to Watch",
            "Mastering the Art of Public Speaking",
            "A Beginner's Guide to Investing in Stocks",
            "How to Decorate Your Home on a Budget",
            "The Role of AI in Modern Businesses"
        };
        String[] blogUrls = {
            "www.blogA.com/10-tips-for-effective-time-management",
            "www.blogB.com/how-to-boost-your-productivity-at-work",
            "www.blogC.com/the-ultimate-guide-to-healthy-eating",
            "www.blogD.com/exploring-the-benefits-of-meditation",
            "www.blogE.com/5-must-visit-destinations-for-your-next-vacation",
            "www.blogF.com/the-future-of-technology-trends-to-watch",
            "www.blogG.com/mastering-the-art-of-public-speaking",
            "www.blogH.com/a-beginners-guide-to-investing-in-stocks",
            "www.blogI.com/how-to-decorate-your-home-on-a-budget",
            "www.blogJ.com/the-role-of-ai-in-modern-businesses"
        };

        random.setSeed(seed);

        Proposal proposal = new Proposal();
        
        proposal.setBlogLive(getRandomBoolean(seed));
        proposal.setContentReady(getRandomBoolean(seed));
        proposal.setInvoicePaid(getRandomBoolean(seed));
        proposal.setInvoiceReceived(getRandomBoolean(seed));
        proposal.setProposalAccepted(getRandomBoolean(seed));

        LocalDateTime[] dates = generateDates();
        proposal.setDateCreated(dates[random.nextInt(10)]);
        if(proposal.isProposalAccepted()) {
            proposal.setDateAcceptedBySupplier(dates[random.nextInt(10)]);
        }
        if(proposal.isInvoiceReceived()) {
            proposal.setDateInvoiceReceived(dates[random.nextInt(10)]);
        }
        if(proposal.isInvoicePaid()) {
            proposal.setDateInvoicePaid(dates[random.nextInt(10)]);
        }
        if(proposal.isProposalSent()) {
            proposal.setDateSentToSupplier(dates[random.nextInt(10)]);
        }
        if(proposal.isBlogLive()) {
            proposal.setDateBlogLive(dates[random.nextInt(10)]);
            proposal.setLiveLinkTitle(blogTitles[random.nextInt(blogTitles.length)]);
            proposal.setLiveLinkUrl(blogUrls[random.nextInt(blogUrls.length)]+seed);
        }

        return proposal;
    }

    private boolean getRandomBoolean(int seed) {
        random.setSeed(seed);
        return random.nextBoolean();
    }

    private Demand createTestDemand(int seed) {
        String[] names = {"Acme Corporation", "Globex Industries", "Soylent Corp", "Initech LLC", "Vehement Capital Partners", "Stark Industries", "Wayne Enterprises", "Hooli", "Pied Piper", "Vandelay Industries"};
        String[] urls = {"www.a.com", "www.b.com", "www.c.com", "www.d.com", "www.e.com"};
        String[] emails = {"john.doe@example.com", "jane.smith@domain.com", "info@business.net", "support@service.org", "admin@website.com", "contact@company.net", "help@helpdesk.org", "sales@retail.com", "feedback@feedback.net", "noreply@noreply.com"};
        String[] anchorTexts = {"Click here for more information", "Learn more about our services", "Visit our homepage", "Contact us today", "Read our latest blog post", "Sign up for our newsletter", "Check out our latest products", "View our photo gallery", "Download our free ebook", "Register for our upcoming webinar"};
        
        
        random.setSeed(seed);

        Demand demand = new Demand();
        demand.setName(names[random.nextInt(names.length)]);
        demand.setUrl(urls[random.nextInt(urls.length)] + seed);
        demand.setCategories(pickRandomCategories(createTestCategories()));
        demand.setCreatedBy(emails[random.nextInt(emails.length)]);
        demand.setUpdatedBy(emails[random.nextInt(emails.length)]);
        demand.setAnchorText(anchorTexts[random.nextInt(anchorTexts.length)]);
        demand.setDaNeeded(random.nextInt(50));
        demand.setRequested(generateDates()[random.nextInt(10)]);

        return demand;
    }

    private LocalDateTime[] generateDates() {
        LocalDateTime[] times = new LocalDateTime[10];
        LocalDateTime now = LocalDateTime.now();

        for (int i = 0; i < times.length; i++) {
            long randomSeconds = ThreadLocalRandom.current().nextLong(7 * 24 * 60 * 60);
            times[i] = now.minus(randomSeconds, ChronoUnit.SECONDS);
        }

        return times;
    }

    private DemandSite createTestDemandSite(int seed) {
        String[] names = {"Acme Corporation", "Globex Industries", "Soylent Corp", "Initech LLC", "Vehement Capital Partners", "Stark Industries", "Wayne Enterprises", "Hooli", "Pied Piper", "Vandelay Industries"};
        String[] urls = {"www.a.com", "www.b.com", "www.c.com", "www.d.com", "www.e.com", "www.f.com", "www.g.com", "www.h.com", "www.i.com", "www.j.com"};
        String[] emails = {"john.doe@example.com", "jane.smith@domain.com", "info@business.net", "support@service.org", "admin@website.com", "contact@company.net", "help@helpdesk.org", "sales@retail.com", "feedback@feedback.net", "noreply@noreply.com"};
        
        random.setSeed(seed);

        DemandSite demandSite = new DemandSite();
        demandSite.setName(names[random.nextInt(names.length)]);
        demandSite.setUrl(urls[random.nextInt(urls.length)]+seed);
        demandSite.setCategories(pickRandomCategories(createTestCategories()));
        demandSite.setEmail(emails[random.nextInt(emails.length)]);
        demandSite.setCreatedBy(emails[random.nextInt(emails.length)]);
        demandSite.setUpdatedBy(emails[random.nextInt(emails.length)]);
        return demandSite;
    }

    private Supplier createTestSupplier(int seed) {
        String[] names = {"Supplier A", "Supplier B", "Supplier C", "Supplier D", "Supplier E", "Supplier F", "Supplier G", "Supplier H", "Supplier I", "Supplier J"};
        String[] emails = {"rdomloge@gmail.com", "rdomloge@hotmail.com", "rdomloge@hot-male.com", "ramsay.domloge@bca.com", 
            "chris.p@frontpageadvantage.com", "lucy.p@frontpageadvantage.com", "frdomloge@gmail.com", "sdomloge@gmail.com",
            "asdf@tesco.net", "fdsa@tesco.net", "asdf@tesco.com", "asdf@tesco.com", "asdf@ibm.com", "fdas@ibm.com"};
        String[] websites = {"https://www.disney.com", "https://www.ibm.com", "https://www.tesco.com", "https://www.github.com", 
            "https://www.microsoft.com"};
        int[] weWriteFees = {10, 20, 30, 40, 50, 60, 70, 80, 90, 100};
        String[] currencies = {"$", "P"};


        random.setSeed(seed);

        Supplier supplier = new Supplier();
        supplier.setName(names[random.nextInt(names.length)]);
        supplier.setEmail(emails[random.nextInt(emails.length)]);
        supplier.setWebsite(websites[random.nextInt(websites.length)]+seed);
        supplier.setWeWriteFee(weWriteFees[random.nextInt(weWriteFees.length)]);
        supplier.setWeWriteFeeCurrency(currencies[random.nextInt(currencies.length)]);
        supplier.setThirdParty(false);
        supplier.setCreatedBy(emails[random.nextInt(emails.length)]);
        supplier.setUpdatedBy(emails[random.nextInt(emails.length)]);
        supplier.setDa(random.nextInt(100));
        supplier.setDisabled(false);
        supplier.setCategories(pickRandomCategories(createTestCategories()));

        return supplier;
    }

    private List<Category> pickRandomCategories(List<Category> categories) {
        List<Category> shuffled = new ArrayList<>(categories);
        Collections.shuffle(shuffled);
        int count = random.nextInt(3) + 1;  // Pick a random number between 1 and 3
        return shuffled.subList(0, count);
    }   

    private List<Category> createTestCategories() {
        List<Category> categories = new ArrayList<>();

        String[] businessTypes = {"Retail", "Healthcare", "Technology", "Finance", "Manufacturing", "Agriculture", 
            "Construction", "Education", "Transportation", "Utilities", "Wholesale", "Information", "Real Estate"};

        for (String businessType : businessTypes) {
            Category category = new Category();
            category.setName(businessType);
            
            Category dbCategory = categoryRepo.findByNameIgnoreCase(businessType);
            if(null == dbCategory) {
                categories.add(categoryRepo.save(category));
            }
            else {
                categories.add(dbCategory);
            }
        }

        return categories;
    }
    // Implement createTestSupplier, createTestDemandSite, createTestDemand, createTestProposal, createTestPaidLink methods
}
