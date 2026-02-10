package com.domloge.slinkylinky.stats.moz;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MozPageLink {

    @Getter
    @Setter
    public static class Page {
        private String page;
		private String subdomain;
		private String root_domain;
		private String title;
		private String last_crawled;
        private int page_authority;
		private int domain_authority;
        
        public Page() {
        }
    }
    
    private Page source;
    private Page target;

    private String anchor_text;
	private String date_first_seen;
    private String date_last_seen;
    private String date_disappeared;
    private boolean nofollow;
	private boolean redirect;
	private boolean rel_canonical;
	private boolean via_redirect;
	private boolean via_rel_canonical;
}
