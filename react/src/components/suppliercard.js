'use client'

import CategoriesCard from '@/components/categoriescard'
import Image from 'next/image'
import Icon from '@/components/shipping.png'
import Link from 'next/link'

export default function SupplierCard({supplier, editable, linkable}) {
    return (
        <div className="list-card card">
            
            <Image src={Icon} width={32} height={32} alt="Shipping icon"/>
            {supplier.thirdParty ? 
                <p className='text-blue-500 font-bold text-right float-right'>3rd</p>
            : null}
            {editable ?
            <Link href={"/supplier/"+supplier.id}>
                <p className='text-right float-right'>Edit</p>
            </Link>
            :null}
            <div className={supplier.disabled?"text-gray-300":""}>{supplier.name}</div>
            <div>DA: {supplier.da}</div>
            {linkable ?
                <>
                <Link href={supplier.website}>
                    <p className="truncate">Website: {supplier.website}</p>
                </Link>
                 <Link href={"mailto:"+supplier.email}>
                    <p className="truncate">Email: {supplier.email}</p>
                </Link>
                </>
            :
                <>
                <p className="truncate">Website: {supplier.website}</p>
                <p className="truncate">Email: {supplier.email}</p>
                </>
            }
           
            <div>Fee: {supplier.weWriteFeeCurrency}{supplier.weWriteFee}</div>
            <div className='grid grid-cols-3 gap-x-4 inline-grid auto-cols-min'>
                <div className='col-span-2'>SEM rush authority</div>
                <div>{supplier.semRushAuthorityScore}</div>
            
                <div className='col-span-2'>SEM rush UK monthly</div>
                <div>{supplier.semRushUkMonthlyTraffic}</div>
            
                <div className='col-span-2'>SEM rush UK Jan &apos;23</div>
                <div>{supplier.semRushUkJan23Traffic}</div>
            </div>
            <CategoriesCard categories={supplier.categories}/>
        </div>
    )
}