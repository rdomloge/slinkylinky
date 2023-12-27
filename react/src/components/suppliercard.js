'use client'

import CategoriesCard from '@/components/categoriescard'
import Image from 'next/image'
import Icon from '@/components/shipping.png'
import DaIcon from '@/components/authority.svg'
import LinkIcon from '@/components/link.svg'
import EmailIcon from '@/components/email.svg'
import MoneyIcon from '@/components/tag.svg'
import ThirdPartyIcon from '@/components/third-party.svg'
import Link from 'next/link'

export default function SupplierCard({supplier, editable, linkable}) {
    return (
        <div className="list-card card relative">
            {supplier.thirdParty ? 
                <Image className='third-party' src={ThirdPartyIcon} width={42} height={42} alt="Third party icon" tooltip="Third party"/>
            : null}
            
            <Image src={Icon} width={32} height={32} alt="Shipping icon"/> 
            
            {editable ?
            <Link href={"/supplier/"+supplier.id}>
                <p className='text-right float-right'>Edit</p>
            </Link>
            :null}
            <div className={"text-xl my-2 "+(supplier.disabled?"text-gray-300":"")}>{supplier.name}</div>
            
            <div className='grid grid-cols-12'>
                {linkable ?
                    <>
                        <Image className='col-span-1 inline-block ' src={LinkIcon} alt="link" width={20} height={20}/>
                        <Link href={supplier.website} className='col-span-11'>
                            <span className='align-middle truncate'>{supplier.website}</span>
                        </Link>
                        <Image className='col-span-1 ' src={EmailIcon} alt="email" width={20} height={20}/>
                        <Link href={"mailto:"+supplier.email} className='col-span-11'>
                            <span className='align-middle truncate'>{supplier.email}</span>
                        </Link>
                    </>
                :
                    <>
                        <Image className='col-span-1 ' src={LinkIcon} alt="link" width={20} height={20}/>
                        <span className='col-span-11 align-middle truncate'>{supplier.website}</span>
                        <Image className='col-span-1 ' src={EmailIcon} alt="email" width={20} height={20}/>
                        <span className='col-span-11 align-middle truncate'>{supplier.email}</span>
                    </>
            ***REMOVED***
                <Image className='col-span-1 ' src={DaIcon} alt="da" width={20} height="auto"/>
                <span className='col-span-11 align-middle text-lg font-bold'>{supplier.da}</span>
                
                <Image className='col-span-1' src={MoneyIcon} alt="money" width={25} height="auto"/> 
                <span className='col-span-11 align-middle'>{supplier.weWriteFeeCurrency}{supplier.weWriteFee}</span>
            </div>
            <table className='table-auto gap-2'>
                <tbody>
                <tr>
                    <td className='pr-4'>SEM rush authority</td>
                    <td className='text-right'>{supplier.semRushAuthorityScore}</td>
                </tr>
                <tr>
                    <td className='pr-4'>SEM rush UK monthly</td>
                    <td className='text-right'>{supplier.semRushUkMonthlyTraffic}</td>
                </tr>
                <tr>
                    <td className='pr-4'>SEM rush UK Jan &apos;23</td>
                    <td className='text-right'>{supplier.semRushUkJan23Traffic}</td>
                </tr>
                </tbody>
            </table>
            <CategoriesCard categories={supplier.categories}/>
        </div>
    )
}