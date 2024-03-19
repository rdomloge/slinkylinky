import AsyncSelect from 'react-select/async';
import React, {useState, useEffect} from 'react'

export default function CategorySelector({changeHandler, label, initialValue}) {

    const [allCategories, setAllCategories] = useState()

    const useableInitialValue = initialValue ? initialValue.map(c=>({value:extractUrl(c), label: c.name})) : []


    function extractUrl(category) {

        if(category._links) {
            const url = category._links.self.href
            if(url.indexOf('{') > -1) return url.substring(0, url.indexOf('{'))
            else return url
        }
        else {
            const url = location.protocol + "//" + location.hostname + ":" + location.port + "/.rest/categories/" + category.id
            console.log("Build URL: "+url)
            return url
        }
    }

    const findCategories = (inputValue, callback) => {
        console.log("Fetching categories like "+inputValue)
        fetch(buildUrlForInputValue(inputValue))
            .then(res => res.json())
            .then(
                json => callback(json.map(c => ({value: "/categories/"+c.id, label: c.name}))))
    }

    function buildUrlForInputValue(inputValue) {
        if(inputValue) {
            return "/.rest/categories/search/findByNameContainsIgnoreCaseAndDisabledFalseOrderByNameAsc?name="+inputValue
        }
        else return "/.rest/categories/search/findAllByDisabledFalseOrderByNameAsc";
    }

    return (
        <div className="w-full px-3 ">
            <label className="block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2" htmlFor="grid-name">
                {label}
            </label>
            <AsyncSelect
                instanceId={"this-should-be-unique-on-the-page"}
                onChange={changeHandler}
                defaultOptions
                defaultValue={useableInitialValue}
                cacheOptions
                closeMenuOnSelect={false}
                isMulti
                loadOptions={findCategories}
                loadingMessage={() => console.log("Loading")}
             />
        </div>
    );
}