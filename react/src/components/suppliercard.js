'use client'

import CategoriesCard from '@/components/categoriescard'
import Image from 'next/image'
import Icon from '@/components/shipping.png'

export default function SupplierCard({supplier}) {
    return (
        <div className="list-card card">
            
            <Image src={Icon} width={32} height={32} alt="Shipping icon"/>
            <div>{supplier.name}</div>
            <div>DA: {supplier.da}</div>
            <div>Website: {supplier.website}</div>
            <div>Email: {supplier.email}</div>
            <div>Fee: &pound;{supplier.weWriteFee}</div>
            <div>SEM rush authority: {supplier.semRushAuthorityScore}</div>
            <div>SEM rush UK monthly: {supplier.semRushUkMonthlyTraffic}</div>
            <div>SEM rush UK Jan &apos;23: {supplier.semRushUkJan23Traffic}</div>
            <CategoriesCard categories={supplier.categories}/>
        </div>
    )
}