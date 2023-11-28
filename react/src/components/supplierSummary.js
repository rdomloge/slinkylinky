export default function SupplierSummary({supplier}) {
    if(supplier) {

        return(
            <div>
                <div>
                    <span className="mr-2 text-2xl">&quot;{supplier.name}&quot;</span>
                    <span className="mr-2 text-2xl">DA-{supplier.da}</span>
                    <span className="mr-2 text-2xl">&pound;{supplier.weWriteFee}</span>
                </div>
                <div className="grid grid-cols-2">
                    <span className="mr-2">Website: {supplier.website}</span>
                    <span className="mr-2">Email: {supplier.email}</span>
                </div>
            </div>
        );
    }
    else return <>Loading...</>
}