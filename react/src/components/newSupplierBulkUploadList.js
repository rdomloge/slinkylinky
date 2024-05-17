import Image from 'next/image'
import Icon from '@/components/left-arrow.svg'

export default function NewSupplierBulkUploadList({data, selectionHandler}) {


    return (
        <div className="max-h-96 h-auto overflow-y-auto drop-shadow shadow-xl border border-slate-300 p-4 rounded-l-3xl bg-slate-200">
            <table>
            <thead>
                <tr>
                    <th></th>
                    <th className="text-left text-sm">Website</th>
                    <th className="text-left text-sm">Cost</th>
                </tr>
            </thead>
            <tbody>
                {data.map((row, i) => (
                    <tr key={i}>
                        <td><Image src={Icon} width={24} height={24} alt="Select" className='cursor-pointer' onClick={()=>selectionHandler(row.website, row.weWriteFee)}/></td>
                        <td className="pr-4">{row.website}</td>
                        <td className="text-right">£{row.weWriteFee}</td>
                    </tr>
                ))}
            </tbody>
            </table>
        </div>
    )
}