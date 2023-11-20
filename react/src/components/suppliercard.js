'use client'

import CategoriesCard from '@/components/categoriescard'

export default function SupplierCard({supplier}) {
    return (
        <div className="card">
            <div>{supplier.name}</div>
            <div>DA: {supplier.da}</div>
            <div>Website: {supplier.website}</div>
            <div>Email: {supplier.email}</div>
            <CategoriesCard categoriesUrl={supplier._links.categories.href}/>
        </div>
    )
}