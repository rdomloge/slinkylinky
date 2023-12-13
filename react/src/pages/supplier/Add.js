import AddOrEditSupplier from "@/components/AddOrEditSupplier";
import Layout from "@/components/layout";
import PageTitle from "@/components/pagetitle";

export default function NewSupplier() {
    return (
        <Layout>
            <PageTitle title="New supplier"/>
            <AddOrEditSupplier supplier={({})}/> 
        </Layout>
    )
}