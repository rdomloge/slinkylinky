export default function SupplierSummary({supplier}) {
    if(supplier) {

        return(
            <div>
                {supplier.thirdParty ? 
                    <span className="mr-2 text-2xl">{supplier.name}</span> 
                : 
                    <>
                    <span className="mr-2 text-2xl">{supplier.domain}</span>
                    <span className="mr-2 text-2xl">DA-{supplier.da}</span>
                    <span className="mr-2 text-2xl">{supplier.weWriteFeeCurrency}{supplier.weWriteFee}</span>
                    </>
                }
                
            </div>
        );
    }
    else return <>Loading...</>
}