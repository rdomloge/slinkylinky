'use client'

import CategoriesCard from '@/components/categoriescard'

export default function SupplierCard({supplier}) {
    return (
        <div className="list-card card">
            <div>{supplier.name}</div>
            <div>DA: {supplier.da}</div>
            <div>Website: {supplier.website}</div>
            <div>Email: {supplier.email}</div>
            <div>Fee: &pound;{supplier.weWriteFee}</div>
            <div>SEM rush authority: {supplier.semRushAuthorityScore}</div>
            <div>SEM rush UK monthly: {supplier.semRushUkMonthlyTraffic}</div>
            <div>SEM rush UK Jan'23: {supplier.semRushUkJan23Traffic}</div>
            <CategoriesCard categoriesUrl={supplier._links.categories.href}/>
        </div>
    )
}