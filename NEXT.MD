1. routes is private var on router, so it cannot be accessed
2. what we could do is add them to a field list in router wrapper, adn print them out later in app wrapper
3. we can use mirror to create some kind of function that will accept i guess lit of middlewraes, list of controllers for specific router, and then use mirror to set it
4. overkill for now, dont bother much
5. 