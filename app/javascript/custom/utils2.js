const BREWERIES = {};

const handleResponse = (breweries) => {
  BREWERIES.list = breweries;
  BREWERIES.show();
};

const createTableRow = (brewery) => {
    const tr = document.createElement("tr");
    tr.classList.add("tablerow");
    const breweryname = tr.appendChild(document.createElement("td"));
    breweryname.innerHTML = brewery.name;
    const year = tr.appendChild(document.createElement("td"));
    year.innerHTML = brewery.year;
    const beer_number = tr.appendChild(document.createElement("td"));
    beer_number.innerHTML = brewery.beer.number;
    const active = tr.appendChild(document.createElement("td"));
    active.innerHTML = brewery.active;

  return tr;
  
  };
  
  BREWERIES.show = () => {
    document.querySelectorAll(".tablerow").forEach((el) => el.remove());
    const table = document.getElementById("brewerytable");
  
    BREWERIES.list.forEach((brewery) => {
      const tr = createTableRow(brewery);
      table.appendChild(tr);
    });
  };

  BREWERIES.sortByName = () => {
    BREWERIES.list.sort((a, b) => {
      return a.name.toUpperCase().localeCompare(b.name.toUpperCase());
    });
  };

  BREWERIES.sortByYear = () => {
    BREWERIES.list.sort((a, b) => {
      return a.year > b.year;
    });
  };

  BREWERIES.sortByBeerNumber = () => {
    BREWERIES.list.sort((a, b) => {
      return a.beer.number > b.beer.number;
    });
  };

  const breweries = () => {
    //if (document.querySelectorAll("#beertable").length < 1) return;
  
    document.getElementById("name").addEventListener("click", (e) => {
      e.preventDefault;
      BREWERIES.sortByName();
      BREWERIES.show();
    });

    document.getElementById("year").addEventListener("click", (e) => {
        e.preventDefault;
        BREWERIES.sortByYear();
        BREWERIES.show();
      });

    document.getElementById("beer_number").addEventListener("click", (e) => {
        e.preventDefault;
        BREWERIES.sortByBeerNumber();
        BREWERIES.show();
    });
  
    //document.getElementById("style").addEventListener("click", (e) => {
    //  e.preventDefault;
    //  BEERS.sortByStyle();
    //  BEERS.show();
    //});
  
    //document.getElementById("brewery").addEventListener("click", (e) => {
    //  e.preventDefault;
    //  BEERS.sortByBrewery();
    //  BEERS.show();
    //});
  
    fetch("breweries.json")
      .then((response) => response.json())
      .then(handleResponse);
  };
  
  export { breweries };