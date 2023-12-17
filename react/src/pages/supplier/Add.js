import AddOrEditSupplier from "@/components/AddOrEditSupplier";
import Layout from "@/components/Layout";
import PageTitle from "@/components/pagetitle";

export default function NewSupplier() {
    return (
        <Layout>
            <PageTitle title="New supplier"/>
            <AddOrEditSupplier supplier={({})}/> 
        </Layout>
    )
}