import Layout from "@/components/layout/Layout";
import PageTitle from "@/components/pagetitle";
import AddOrEditSupplier from "@/components/AddOrEditSupplier";
import React, {useState, useEffect} from 'react';
import { useRouter } from 'next/router'

export default function EditSupplier() {
    const router = useRouter()
    const [supplier, setSupplier] = useState()
    const [supplierName, setSupplierName] = useState('');
    const [supplierWebsite, setSupplierWebsite] = useState('')
    const [supplierSource, setSupplierSource] = useState('')
    const [supplierEmail, setSupplierEmail] = useState('')
    const [supplierWeWriteFee, setSupplierWeWriteFee] = useState(0)

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
                    setSupplierName(s.name);
                    setSupplierWebsite(s.website);
                    setSupplierSource(s.source);
                    setSupplierEmail(s.email);
                    setSupplierWeWriteFee(s.weWriteFee);
                });
            }
        }, [router.isReady, router.query.supplierid]);

    return (
        <Layout>
            <PageTitle id="supplier-edit-id" title="Edit supplier"/>
            {supplier ?
                <AddOrEditSupplier supplier={supplier} 
                    supplierName={supplierName} setSupplierName={setSupplierName} 
                    supplierWebsite={supplierWebsite} setSupplierWebsite={setSupplierWebsite}
                    supplierFee={supplierWeWriteFee} setSupplierFee={setSupplierWeWriteFee}
                    supplierSource={supplierSource} setSupplierSource={setSupplierSource}
                    supplierEmail={supplierEmail} setSupplierEmail={setSupplierEmail}/>
            : null}
        </Layout>
    )
}