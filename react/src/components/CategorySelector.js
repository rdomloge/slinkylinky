
import AsyncSelect from 'react-select/async';
import React, {useState, useEffect} from 'react'

export default function CategorySelector({changeHandler}) {
    
  
    const findCategories = (inputValue, callback) => {
        fetch("http://localhost:8080/categories")
            .then(res => res.json())
            .then(
                json => callback(json._embedded.categories.map(c => ({ value: c._links.self.href, label: c.name })))
            )
***REMOVED***

    return (
        <AsyncSelect
            onChange={changeHandler}
            defaultOptions
            cacheOptions
            closeMenuOnSelect={false}
            isMulti
            loadOptions={findCategories}
            loadingMessage={"Loading categories"}
        />
    );
}