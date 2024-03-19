import Layout from "@/components/layout/Layout";
import PageTitle from "@/components/pagetitle";
import AddOrEditSupplier from "@/components/AddOrEditSupplier";
import React, {useState, useEffect} from 'react';
import { useRouter } from 'next/router'

export default function EditSupplier() {
    const router = useRouter()
    const [supplier, setSupplier] = useState()

    useEffect(
        () => {
            if(router.isReady) {
                const supplierUrl = "/.rest/suppliers/"+router.query.supplierid+"?projection=fullSupplier";
                fetch(supplierUrl, {
                    headers: {'Cache-Control': 'no-cache'}
                })
                .then( (res) => res.json())
                .then( (s) => {
                    s.id = router.query.supplierid
                    setSupplier(s);
                });
            }
        }, [router.isReady, router.query.supplierid]);

    return (
        <Layout>
            <PageTitle title="Edit supplier"/>
            {supplier ?
                <AddOrEditSupplier supplier={supplier}/>
            : null}
        </Layout>
    )
}