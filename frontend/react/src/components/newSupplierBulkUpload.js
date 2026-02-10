import { useState } from "react";
import Modal from "./atoms/Modal";
import TextInput from "./atoms/TextInput";
import { StyledButton } from "./atoms/Button";
import Papa from "papaparse";
import { checkIfSupplierExists, checkIfSupplierIsBlacklisted, url_domain } from "./Util";
import { useSession } from "next-auth/react";


export default function NewSupplierBulkUpload({dismissHandler, submitHandler}) {

    const { data: session } = useSession();
    const [name, setName] = useState('');
    const [email, setEmail] = useState('');
    const [source, setSource] = useState('');
    const [filename, setFilename] = useState(null);
    const [data, setData] = useState([]);
    const [rowsProcessed, setRowsProcessed] = useState(0);
    const [dataSample, setDataSample] = useState([]);
    const [errorMessage, setErrorMessage] = useState('');
    const [filtering, setFiltering] = useState(false);
    const [processingCount, setProcessingCount] = useState(-1);
    const [existingCount, setExistingCount] = useState(-1);
    const [blacklistedCount, setBlacklistedCount] = useState(-1);
    const [filteredData, setFilteredData] = useState([]);


    const dataSampleSize = 7;

    const modalDismissHandler = () => {
        dismissHandler();
        setDataSample([]);
        setData([]);
        setFilename(null);
        setRowsProcessed(0);
        setErrorMessage(null);
        setFiltering(false);
        setProcessingCount(-1);
        setExistingCount(-1);
        setBlacklistedCount(-1);
    }

    async function filterOutExistingAndBlackListed(data) { // we have to pass the data in because the state is not updated immediately
        console.log("Filtering out existing and blacklisted suppliers");
        setFiltering(true);
        setBlacklistedCount(0);
        setExistingCount(0);
        setProcessingCount(0);
        var localExistingCount = 0;
        var localBlacklistedCount = 0;

        const remaining = [];
        // Filter out existing suppliers
        for (var i=0; i<data.length; i++) {
            const website = data[i].website;
            if(null === url_domain(website)) {
                console.log("Invalid domain: "+website+ " - ignoring this entry");
                continue;
            }
            const exists = await checkIfSupplierExists(website, session);
            if(exists) {
                console.log("Supplier "+website+" exists - ignoring");
                localExistingCount++;
                setExistingCount(localExistingCount);
            }
            else {
                const blacklisted = await checkIfSupplierIsBlacklisted(website, session);
                if(blacklisted) {
                    console.log("Supplier "+website+" is blacklisted - ignoring");
                    localBlacklistedCount++;
                    setBlacklistedCount(localBlacklistedCount);
                    console.log("There are now "+localBlacklistedCount+" blacklisted suppliers");
                }
                else {
                    console.log("Supplier "+website+" is not blacklisted or existing - keeping");
                    remaining.push(data[i]);
                }
            }

            setProcessingCount(i+1);
        }
        console.log("After filtering out existing/blacklisted suppliers, there are "+(remaining.length)+" suppliers left");
        
        if(remaining.length > dataSampleSize) {
            setDataSample(remaining.slice(0, dataSampleSize));
        }
        else {
            setDataSample(remaining);
        }
        setFilteredData(remaining);
        setFiltering(false);
    }

    const onFileChangeHandler = (event) => {
        if (event.target.files && event.target.files[0]) {
            const i = event.target.files[0];
            setFilename(i);

            // Initialize a reader which allows user
            // to read any file or blob.
            const reader = new FileReader();
    
            // Event listener on reader when the file
            // loads, we parse it and set the data.
            reader.onload = async ({ target }) => {
                const csv = Papa.parse(target.result, {
                    header: true,
                });
                
                if(csv.errors.length > 0) {
                    console.log(csv.errors);
                    // return;
                }

                if(csv.data.length > 0) {
                    if( ! csv.data[0].website || ! csv.data[0].weWriteFee) {
                        console.log("Invalid CSV format");
                        setErrorMessage("Invalid format - file should contain 2 columns - 'website' and 'weWriteFee' and should have a header row.");
                        setDataSample([]);
                        setData([]);
                        setRowsProcessed(0);
                        return;
                    }
                    else {
                        setErrorMessage(null);
                    }
                }

                console.log(csv);
                setData(csv.data);
                setRowsProcessed(csv.data.length);
                if(csv.data.length > dataSampleSize) {
                    setDataSample(csv.data.slice(0, dataSampleSize));
                }
                else {
                    setDataSample(csv.data);
                }
                filterOutExistingAndBlackListed(csv.data);
            };
            reader.readAsText(i);
        }
    };

    return (
        <Modal
            title="Bulk upload"
            content="Upload a CSV file with the supplier data"
            dismissHandler={modalDismissHandler}>
            <div className="flex">
                <div className="flex-1">
                    <TextInput label="Name" binding={name} changeHandler={(e)=>setName(e)} />
                    <TextInput label="Email" binding={email} changeHandler={(e)=>setEmail(e)} />
                    <TextInput label="Source" binding={source} changeHandler={(e)=>setSource(e)}/>
                    <div className="p-4 pt-6">
                        <input type="file" onChange={onFileChangeHandler} accept=".csv" />
                        <p className="text-xs font-bold">{rowsProcessed ? ("File contains "+rowsProcessed+" rows") : ""}</p>
                        {errorMessage ? <p className="text-xs text-red-500">{errorMessage}</p> : null}
                    </div>
                </div>
                <div className="m-6 p-4 bg-slate-200">
                    <h1 className="text-lg font-bold">Sample data</h1>
                    {dataSample.length === 0 ? 
                        <p className="italic">Select file</p> 
                    :
                        <table>
                        <thead>
                            <tr>
                                <th className="text-left text-sm">Website</th>
                                <th className="text-left text-sm">Cost</th>
                            </tr>
                        </thead>
                        <tbody>
                            {dataSample.map((row, i) => (
                                <tr key={i}>
                                    <td className="pr-4">{row.website}</td>
                                    <td className="text-right">£{row.weWriteFee}</td>
                                </tr>
                            ))}
                        </tbody>
                        </table>
                    }
                </div>
            </div>
            <div className="w-2/3 mt-6">
                {filtering ? 
                    <>
                    <p className="mb-4">Filtering...
                        <svg aria-hidden="true" className="w-6 h-6 text-gray-200 animate-spin dark:text-gray-600 fill-blue-600 inline-block ml-4" 
                            viewBox="0 0 100 101" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path d="M100 50.5908C100 78.2051 77.6142 100.591 50 100.591C22.3858 100.591 0 78.2051 0 50.5908C0 22.9766 22.3858 0.59082 50 0.59082C77.6142 0.59082 100 22.9766 100 50.5908ZM9.08144 50.5908C9.08144 73.1895 27.4013 91.5094 50 91.5094C72.5987 91.5094 90.9186 73.1895 90.9186 50.5908C90.9186 27.9921 72.5987 9.67226 50 9.67226C27.4013 9.67226 9.08144 27.9921 9.08144 50.5908Z" fill="currentColor"/>
                            <path d="M93.9676 39.0409C96.393 38.4038 97.8624 35.9116 97.0079 33.5539C95.2932 28.8227 92.871 24.3692 89.8167 20.348C85.8452 15.1192 80.8826 10.7238 75.2124 7.41289C69.5422 4.10194 63.2754 1.94025 56.7698 1.05124C51.7666 0.367541 46.6976 0.446843 41.7345 1.27873C39.2613 1.69328 37.813 4.19778 38.4501 6.62326C39.0873 9.04874 41.5694 10.4717 44.0505 10.1071C47.8511 9.54855 51.7191 9.52689 55.5402 10.0491C60.8642 10.7766 65.9928 12.5457 70.6331 15.2552C75.2735 17.9648 79.3347 21.5619 82.5849 25.841C84.9175 28.9121 86.7997 32.2913 88.1811 35.8758C89.083 38.2158 91.5421 39.6781 93.9676 39.0409Z" fill="currentFill"/>
                        </svg>
                    </p> 
                    
                    </>
                : 
                    null
                }
                {
                    processingCount >= 0 ? 
                    <p className=" border border-sky-500 bg-sky-100 p-2 inline-block w-2/3">Processed {processingCount} suppliers</p>
                :
                    null
                }
                {
                    existingCount > 0 ? 
                    <p className="pl-6 p-2 inline-block w-2/3 border border-orange-500 bg-orange-100"> &gt; Found {existingCount} existing suppliers</p>
                :
                    null
                }
                {
                    blacklistedCount > 0 ? 
                    <p className="pl-6 p-2 inline-block w-2/3 border border-red-500 bg-red-100"> &gt; Found {blacklistedCount} blacklisted suppliers</p>
                :
                    null
                }
            </div>

            <StyledButton label="Start" submitHandler={()=>submitHandler(name, email, source, filteredData)} 
                type="primary" extraClass="float-right mt-6" enabled={name && email && source && ! filtering}/>
        </Modal>
    );
}