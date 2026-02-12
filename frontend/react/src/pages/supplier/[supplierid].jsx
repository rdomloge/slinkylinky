import Layout from "@/components/layout/Layout";
import PageTitle from "@/components/pagetitle";
import AddOrEditSupplier from "@/components/AddOrEditSupplier";
import React, {useState, useEffect} from 'react';
import { useParams } from 'react-router-dom'
import { fetchWithAuth } from "@/utils/fetchWithAuth";

export default function EditSupplier() {
    const { supplierid } = useParams()
    const [supplier, setSupplier] = useState()
    const [supplierName, setSupplierName] = useState('');
    const [supplierWebsite, setSupplierWebsite] = useState('')
    const [supplierSource, setSupplierSource] = useState('')
    const [supplierEmail, setSupplierEmail] = useState('')
    const [supplierWeWriteFee, setSupplierWeWriteFee] = useState(0)

    useEffect(
        () => {
            const supplierUrl = "/.rest/suppliers/"+supplierid+"?projection=fullSupplier";
            fetchWithAuth(supplierUrl, {
                headers: {'Cache-Control': 'no-cache'}
            })
            .then( (res) => res.json())
            .then( (s) => {
                s.id = supplierid
                setSupplier(s);
                setSupplierName(s.name);
                setSupplierWebsite(s.website);
                setSupplierSource(s.source);
                setSupplierEmail(s.email);
                setSupplierWeWriteFee(s.weWriteFee);
            });
        }, [supplierid]);

    return (
        <Layout pagetitle="Edit supplier">
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