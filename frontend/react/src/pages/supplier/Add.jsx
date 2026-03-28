import AddOrEditSupplier from "@/components/AddOrEditSupplier";
import { StyledButton } from "@/components/atoms/Button";

import Layout from "@/components/layout/Layout";
import NewSupplierBulkUpload from "@/components/NewSupplierBulkUpload";

import { useState } from "react";
import NewSupplierBulkUploadList from "@/components/NewSupplierBulkUploadList";


export default function NewSupplier() {

    const [showBulkUploadModal, setShowBulkUploadModal] = useState(false)
    const [bulkData, setBulkData] = useState(null)
    const [supplierName, setSupplierName] = useState('');
    const [supplierWebsite, setSupplierWebsite] = useState('')
    const [supplierSource, setSupplierSource] = useState('')
    const [supplierEmail, setSupplierEmail] = useState('')
    const [supplierWeWriteFee, setSupplierWeWriteFee] = useState(0)

    const bulkUploadSubmitHandler = (name, email, source, data) => {
        setBulkData(data);
        setShowBulkUploadModal(false);
        setSupplierName(name);
        setSupplierSource(source);
        setSupplierEmail(email);
    }

    const bulkUploadSelectionHandler = (website, cost) => {
        console.log("Selected website: ", website, " with cost: ", cost);
        setSupplierWebsite(website);
        setSupplierWeWriteFee(cost);
    }

    const removeItemFromBulkData = (website) => {
        const newData = bulkData.filter((item) => item.website !== website);
        setBulkData(newData);
    }
    
    return (
        <Layout pagetitle="New supplier">
            <div className="flex items-center justify-between px-6 pt-6 pb-4">
                <h1 id="supplier-add-id" className="pageTitle">New supplier</h1>
                <StyledButton label="Bulk upload" submitHandler={()=>setShowBulkUploadModal(true)} type="secondary" extraClass="!m-0" isText={true}/>
            </div>
            <div className="flex">
                <div className="flex-1">
                    <AddOrEditSupplier supplier={({da: 0, name: "", website: "", source: "", email: "", weWriteFeeCurrency: "£", weWriteFee: 0})}
                        supplierName={supplierName} setSupplierName={setSupplierName} 
                        supplierWebsite={supplierWebsite} setSupplierWebsite={setSupplierWebsite}
                        supplierSource={supplierSource} setSupplierSource={setSupplierSource}
                        supplierEmail={supplierEmail} setSupplierEmail={setSupplierEmail}
                        supplierFee={supplierWeWriteFee} setSupplierFee={setSupplierWeWriteFee}
                        bulkMode={bulkData}
                        bulkSupplierAddedHandler={(website) => {removeItemFromBulkData(website)}}/> 
                </div>
                {bulkData ?
                    <div className="flex-initial">
                        <NewSupplierBulkUploadList data={bulkData} selectionHandler={(website, cost)=>bulkUploadSelectionHandler(website,cost)} />
                    </div>
                :
                    null
                }
                
            </div>
            {showBulkUploadModal ? 
                <NewSupplierBulkUpload dismissHandler={()=>setShowBulkUploadModal(false)} submitHandler={bulkUploadSubmitHandler} />
            : 
                null
            }
        </Layout>
    )
}