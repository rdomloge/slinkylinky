export default function SupplierSummary({supplier}) {
    if(supplier) {

        return(
            <div>
                <div>
                    <span className="mr-2 text-2xl">&quot;{supplier.name}&quot;</span>
                    <span className="mr-2 text-2xl">DA-{supplier.da}</span>
                    <span className="mr-2 text-2xl">&pound;{supplier.weWriteFee}</span>
                </div>
                
            </div>
        );
***REMOVED***
    else return <>Loading...</>
}