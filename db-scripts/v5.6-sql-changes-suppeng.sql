ALTER TABLE IF EXISTS public.engagement
    DROP CONSTRAINT IF EXISTS engagement_status_check;
    
ALTER TABLE IF EXISTS public.engagement
    ADD CONSTRAINT engagement_status_check CHECK 
    (status::text = ANY (
        ARRAY[
            'NEW'::character varying::text, 
            'ACCEPTED'::character varying::text, 
            'DECLINED'::character varying::text, 
            'CANCELLED'::character varying::text,
            'EXPIRED'::character varying::text
        ]
    ));
