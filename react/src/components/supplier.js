'use client'

import React, {useState, useEffect} from 'react'

export default function SupplierCard({supplier}) {
    return (
        <div>
            <div>Supplier: {supplier.name}</div>
            <div>DA: {supplier.da}</div>
            <div>Website: {supplier.website}</div>
            <div>Email: {supplier.email}</div>
        </div>
    )
}