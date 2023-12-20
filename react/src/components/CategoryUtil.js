export function fixForPosting(entity) {

    if( ! entity.categories) {
        console.warn("Entity does not have a categories property - if it's a new object maybe that's OK")
        return;
***REMOVED***

    if(entity.categories.length < 1) {
        console.warn("Enitity has no categories to fix")
***REMOVED***

    entity.categories = entity.categories.map(c => {
        return fixSingleForPosting(c)
***REMOVED***);   
}

function fixSingleForPosting(c) {
    
    if(c._links) return c._links.self.href

    if(c.value) return c.value

    if(c.id) return "/.rest/categories/" + c.id

    if(typeof c === 'string' || c instanceof String) return c

    console.error("Unable to convert "+JSON.stringify(c))
    return {}
}