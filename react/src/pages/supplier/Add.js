import AddOrEditSupplier from "@/components/AddOrEditSupplier";
import Layout from "@/components/layout/Layout";
import PageTitle from "@/components/pagetitle";

export default function NewSupplier() {
    return (
        <Layout>
            <PageTitle title="New supplier"/>
            <AddOrEditSupplier supplier={({da: 0, weWriteFee: 0, name: "", website: "", source: "", email: "", weWriteFeeCurrency: "£", weWriteFee: "0"})}/> 
        </Layout>
    )
}