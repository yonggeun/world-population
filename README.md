# World Population Growth: A information visualization with pointillistic representation 

[![](https://github.com/yonggeun/world-population/blob/master/screenshot/FHD-2020-6-6 18 05 17 00020080.png)

## 1. Introduction

This project depict the world population growth by year. It distinguishes itself by deploying a pointillism animation to represent population growth and density at the same time. To enable this the code calculates the number of dots to be filled in each territory based the ration given. Due to the insufficient computing power in calculating the random position of each dots in real-time the program preloads the verified coords of random dots on each territory based on Perlin noise. The ideal scale between the dataset and each single dot is 1,000,000 population to one single dot though any positive number is valid within the code. 

[watch video](https://youtu.be/Nyny-2q9qUU)

## 2. Purpose
1. To propose an alternative way of representing regional population instead of choropleth mapping method.
2. To combine two relevant data— population density and population growth on the same visual space. 
3. To deliver the significant events in the population growth timeline together with the quantitative information. 

## 3. Installation
1. download processing IDE from [processing.org](https://processing.org/)
2. install the dependencies from [the contributed libraries](https://processing.org/reference/libraries/)
  - Geomerative library

## 4. Data source

1. Estimates. https://www.slavevoyages.org/assessment/estimates. Accessed 3 June 2020.
2, “List of Epidemics.” Wikipedia, 3 June 2020. Wikipedia, https://en.wikipedia.org/w/index.php?title=List_of_epidemics&oldid=960441858.
3. “List of Events Named Massacres.” Wikipedia, 30 May 2020. Wikipedia, https://en.wikipedia.org/w/index.php?title=List_of_events_named_massacres&oldid=959794027.
4. “List of Famines.” Wikipedia, 25 May 2020. Wikipedia, https://en.wikipedia.org/w/index.php?title=List_of_famines&oldid=958757071.
5. “List of Wars by Death Toll.” Wikipedia, 30 May 2020. Wikipedia, https://en.wikipedia.org/w/index.php?title=List_of_wars_by_death_toll&oldid=959762562.
6. Roser, Max, et al. “World Population Growth.” Our World in Data, May 2013. ourworldindata.org, https://ourworldindata.org/world-population-growth.
7. TIMELINE: World History. https://www.wdl.org/en/sets/world-history/timeline/. Accessed 3 June 2020.
8. Total Population. www.gapminder.org, https://www.gapminder.org/data/documentation/gd003/. Accessed 27 May 2020.
9. “World Population History.” World Population. worldpopulationhistory.org, https://worldpopulationhistory.org/. Accessed 3 June 2020.
10. World Population Prospects - Population Division - United Nations. https://population.un.org/wpp/Download/Standard/Population/. Accessed 27 May 2020.

- Map Sources
     1. [Marked up SVG world map](https://github.com/benhodgson/markedup-svg-worldmap)@github
     2. [wikipedia:blank maps](https://en.wikipedia.org/wiki/Wikipedia:Blank_maps#World)
     3. [Free World SVG Map from Simplemaps](https://simplemaps.com/resources/svg-world) I use this version.
     4. Due the the latest update in the names and borders of countries the attached SVG map file differs from the original version.

## 6. Credits

   1. Fonts
      1. Thanks [Google fonts](https://fonts.google.com/). all is Roboto and its family. 
