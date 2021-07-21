<template>
  <div class="data-page">
    <breadcrumb :breadcrumb="breadcrumb" title="Find Data" />
    <div class="container">
      <div class="search-tabs__container">
        <h3>
          Browse categories
        </h3>
        <ul class="search-tabs">
          <li v-for="type in searchTypes" :key="type.label">
            <nuxt-link
              class="search-tabs__button"
              :class="{ active: type.type === $route.query.type }"
              :to="{
                name: 'data',
                query: {
                  type: type.type,
                  q: $route.query.q
                }
              }"
            >
              {{ type.label }}
            </nuxt-link>
          </li>
        </ul>
      </div>
      <div class="search-bar__container">
        <h5>
          Search within "Datasets"
        </h5>
        <search-form
          v-model="searchQuery"
          :q="q"
          @search="submitSearch"
          @clear="clearSearch"

        />
        <div style="display: flex;flex-direction:row">
          <div style="position:relative;display:flex;flex-direction:row;justify-content:flex-end;margin-right:15px">
            <p @click="showAdvancedSearch()" style="margin-top:10px;margin-bottom:5px;margin-right:5px;padding-right:10px;color: blueviolet;cursor:pointer;font-size:15px">Advanced search</p>
            <span @click="showAdvancedSearch()" class="arrow-span"></span>
          </div>
          <div style="margin-top:-3px">
          <!-- <div class="div-pipe" style="width: 1px;height:18px;background: blueviolet;margin-top:15px"></div> -->
            <p @click="" style="margin-top:10px;margin-left: 5px;margin-bottom:5px;color: blueviolet;cursor:pointer;padding: 3px;font-size:15px">Create alerts</p>
          </div>
        </div>
        <div class="div-advanced-search" id="div-advanced-search" style="font-size:14px;display:none;margin-top: -10px;width:135px;padding:5px;background:#f9f2fc;border-radius:3px;border:1px solid blueviolet">
          <input class="radio-button" type="radio" value="Exact match" name="advanced-match" v-model="advancedMatch">
          <label for="Exact match">Exact match</label>
          <br>
          <input class="radio-button" type="radio" value="Any of the words" name="advanced-match" v-model="advancedMatch">
          <label for="Any of the words">Any of the words</label>
        </div>
        <!-- <form autocomplete="off" action="/action_page.php">
          <div class="autocomplete" style="width:300px;">
            <input id="myInput" type="text" name="myCountry" placeholder="Country">
          </div>
          <input type="submit">
        </form> -->
      </div>
    </div>
    <div class="page-wrap container">
      <el-row :gutter="32" type="flex">

        <el-col :span="24">
          <div class="search-heading">
            <!-- <p v-show="!isLoadingSearch && searchData.items.length"> -->
            <p style="width:26%" v-show="!isLoadingSearch && this.searchData.items.length">
              {{ searchHeading }} | Showing
              <pagination-menu
                :page-size="searchData.limit"
                @update-page-size="updateDataSearchLimit"
              />
            </p>
            <!-- <div class="search-heading"> -->
            <p style="width:50%">
              Sort by
              <select style="width:auto;border-radius: 4px;color: #8300bf;border: solid 1px #909399;height:25px;margin-left:5px;font-weight:600;padding:3px">
                <option value="Relevance">Relevance</option>
                <option value="Published Date">Published Date</option>
                <option value="Alphabetical Order">Alphabetical Order</option>
              </select>
            </p>
            <!-- </div> -->
            <el-pagination
              v-if="searchData.limit < searchData.total"
              :small="isMobile"
              :page-size="searchData.limit"
              :pager-count="5"
              :current-page="curSearchPage"
              layout="prev, pager, next"
              :total="searchData.total"
              @current-change="onPaginationPageChange"
              style="width:20%"
            />
          </div>

          <div class="mb-16">
            <div class="active__filter__wrap">
              <div
                v-for="(filter, filterIdx) in filters"
                :key="filter.category"
                class="active__filter__wrap-category"
              >
                <template v-for="(item, itemIdx) in filter.filters">
                  <el-tag
                    v-if="item.value"
                    :key="`${item.key}`"
                    closable
                    @close="clearFilter(filterIdx, itemIdx)"
                  >
                    {{ item.label }}
                  </el-tag>
                </template>
              </div>
            </div>
          </div>
        </el-col>
        </el-row>
          <el-row :gutter="32">
            <el-col
              v-if="searchType.type === 'dataset'"
              :sm="24"
              :md="6"
              :lg="4"
            >

              <div class="dataset-filters table-wrap">
                <h2>Filter datasets by:</h2>
                <h3 class="filter-headers">Status</h3>
                <div class="dataset-filters__filter-group">
                  <el-checkbox-group
                    v-model="datasetFilters"
                    @change="setDatasetFilter"
                  >
                    <el-checkbox label="Public" />
                    <el-checkbox label="Embargoed" />
                  </el-checkbox-group>
                </div>

                <h3 style="padding-top:10px" class="filter-headers">Published Date</h3>
                <div class="dataset-filters__filter-group filtering-section" style="max-height:120px; overflow-y: hidden;font-size:14px;">
                  <!-- <el-checkbox-group
                    v-model="datasetFilters"
                    @change="setDatasetFilter"
                  > -->
                  <div>
                    <input class="radio-button" type="radio" value="Any time" name="publication-date-filter" v-model="PublicationDatePicked">
                    <label for="Any time">Any time</label>
                    <br>
                    <input class="radio-button" type="radio" value="Within the last 24 hours" name="publication-date-filter" v-model="PublicationDatePicked">
                    <label for="Within the last 24 hours">Last 24 hours</label>
                    <br>
                    <input class="radio-button" type="radio" value="Last week" name="publication-date-filter" v-model="PublicationDatePicked">
                    <label for="Last week">Last week</label>
                    <br>
                    <input class="radio-button" type="radio" value="Last month" name="publication-date-filter" v-model="PublicationDatePicked">
                    <label for="Last month">Last month</label>
                    <br>
                    <input class="radio-button" type="radio" value="Older" name="publication-date-filter" v-model="PublicationDatePicked">
                    <label for="Older">Older</label>
                  </div>
                  <!-- </el-checkbox-group> -->
                </div>

                <button @click="seeMoreSection()" class="see-more-btn" id="see-more-btn">Additional filters</button>
                <div id="additional-filters-div" style="display:none">
                <h3 style="padding-top:10px" class="filter-headers">Keyword</h3>
                <div class="dataset-filters__filter-group filtering-section" style="overflow-y: hidden">
                  <input name="keywords-filter" placeholder="Enter a keyword" style="width:90%;border-radius: 4px"></input>
                  <!-- <el-checkbox-group
                    v-model="datasetFilters"
                    @change="setDatasetFilter"
                  >
                    <el-checkbox label="keyword-1" />
                    <el-checkbox label="keyword-2" />
                    <el-checkbox label="keyword-3" />
                    <el-checkbox label="keyword-4" />
                    <el-checkbox label="keyword-6" />
                    <el-checkbox label="keyword-5" />
                  </el-checkbox-group> -->
                </div>
                <h3 style="padding-top:10px" class="filter-headers">Author</h3>
                <div class="dataset-filters__filter-group filtering-section" style="overflow-y: hidden">
                  <input name="authors-filter" placeholder="Enter an author" style="width:90%;border-radius: 4px"></input>
                  <!-- <el-checkbox-group
                    v-model="datasetFilters"
                    @change="setDatasetFilter"
                  >
                    <el-checkbox label="author-1" />
                    <el-checkbox label="author-2" />
                    <el-checkbox label="author-3" />
                    <el-checkbox label="author-4" />
                    <el-checkbox label="author-5" />
                  </el-checkbox-group> -->
                  <!-- <input label="Keywords" placeholder="Type a keyword"></input> -->
                </div>
                <h3 style="padding-top:10px" class="filter-headers">Category</h3>
                <div class="dataset-filters__filter-group filtering-section">
                  <el-checkbox-group
                    v-model="datasetFilters"
                    @change="setDatasetFilter"
                  >
                    <el-checkbox label="category-1" />
                    <el-checkbox label="category-2" />
                    <el-checkbox label="category-3" />
                  </el-checkbox-group>
                </div>
                <div>
                  <button @click="seeLessSection()" class="see-more-btn" id="see-less-btn" style="margin-top:20px">See less</button>
                  <button @click="resetFilters()" class="see-more-btn" id="reset-filters-btn" style="background: #8300BF;color:#fff;margin-top:0">Reset filters</button>
                </div>
              </div>
              </div>
            </el-col>
            <el-col
              :sm="searchColSpan('sm')"
              :md="searchColSpan('md')"
              :lg="searchColSpan('lg')"
            >
              <div v-loading="isLoadingSearch" class="table-wrap">
                <component
                  :is="searchResultsComponent"
                  :key="tableMetadata.size"
                  :table-data="tableData"
                  :table-metadata="tableMetadata"
                  :title-column-width="titleColumnWidth"
                  @sort-change="handleSortChange"
                />
              </div>
            </el-col>
          </el-row>
        </el-col>
      </el-row>
      <div class="search-heading">
        <p v-if="!isLoadingSearch && searchData.items.length">
          {{ searchHeading }} | Showing
          <pagination-menu
            :page-size="searchData.limit"
            @update-page-size="updateDataSearchLimit"
          />
        </p>
        <el-pagination
          v-if="searchData.limit < searchData.total"
          :small="isMobile"
          :page-size="searchData.limit"
          :pager-count="5"
          :current-page="curSearchPage"
          layout="prev, pager, next"
          :total="searchData.total"
          @current-change="onPaginationPageChange"
        />
      </div>
    </div>
    <search-filters
      v-model="filters"
      :visible.sync="isFiltersVisible"
      :is-loading="isLoadingFilters"
      :dialog-title="activeFiltersLabel"
      @input="setTagsQuery"
    />
  </div>
</template>

<script>

// import { request } from 'http'
import {
  assocPath,
  clone,
  compose,
  defaultTo,
  equals,
  flatten,
  find,
  filter,
  head,
  mergeLeft,
  pathOr,
  propEq,
  propOr,
  pluck
} from 'ramda'
import Breadcrumb from '@/components/Breadcrumb/Breadcrumb.vue'
import PageHero from '@/components/PageHero/PageHero.vue'
import PaginationMenu from '@/components/Pagination/PaginationMenu.vue'
import SearchFilters from '@/components/SearchFilters/SearchFilters.vue'
import SearchForm from '@/components/SearchForm/SearchForm.vue'
import * as http from 'http';

const ProjectSearchResults = () =>
  import('@/components/SearchResults/ProjectSearchResults.vue')
const EventSearchResults = () =>
  import('@/components/SearchResults/EventSearchResults.vue')
const DatasetSearchResults = () =>
  import('@/components/SearchResults/DatasetSearchResults.vue')
const OrganSearchResults = () =>
  import('@/components/SearchResults/OrganSearchResults.vue')

const searchResultsComponents = {
  dataset: DatasetSearchResults,
  sparcAward: ProjectSearchResults,
  event: EventSearchResults,
  organ: OrganSearchResults,
  simulation: DatasetSearchResults
}

const countries = ["Afghanistan","Albania","Algeria","Andorra","Angola","Anguilla","Antigua &amp; Barbuda","Argentina","Armenia","Aruba","Australia","Austria","Azerbaijan","Bahamas","Bahrain","Bangladesh","Barbados","Belarus","Belgium","Belize","Benin","Bermuda","Bhutan","Bolivia"]

const searchTypes = [
  {
    label: 'Datasets',
    type: 'dataset',
    filterId: process.env.ctf_filters_dataset_id,
    // dataSource: 'algolia'
    dataSource: 'aqua'
  },
  {
    label: 'Organs',
    type: process.env.ctf_organ_id,
    filterId: process.env.ctf_filters_organ_id,
    dataSource: 'contentful'
  },
  {
    label: 'Projects',
    type: process.env.ctf_project_id,
    filterId: process.env.ctf_filters_project_id,
    dataSource: 'contentful'
  },
  {
    label: 'Simulations',
    type: 'simulation',
    filterId: process.env.ctf_filters_simulation_id,
    dataSource: 'algolia'
  }
]

const advancedSearchOptions = ["Exact match", "here"]

const searchData = {
  limit: 10,
  skip: 0,
  items: [],
  kCoreItems: new Map(),
  order: undefined,
  ascending: false,
  keywords: [],
  authors: []
}

const datasetFilters = ['Public']

const getEmbargoedFilter = (searchType, datasetFilters) => {
  const filters = Array.isArray(datasetFilters)
    ? datasetFilters
    : [datasetFilters]
  if (searchType !== 'dataset') {
    return
  }
  if (filters.includes('Embargoed') && !filters.includes('Public')) {
    return 'embargo:true'
  }
  if (!filters.includes('Embargoed') && filters.includes('Public')) {
    return 'embargo:false'
  }
  return ''
}

import createClient from '@/plugins/contentful.js'
import createAlgoliaClient from '@/plugins/algolia.js'
import { handleSortChange, transformFilters } from './utils'

const client = createClient()
const algoliaClient = createAlgoliaClient()
const algoliaPennseiveIndex = algoliaClient.initIndex('PENNSIEVE_DISCOVER')
const algoliaKCoreIndex = algoliaClient.initIndex('UCSD K-Core')

export default {
  name: 'DataPage',

  components: {
    Breadcrumb,
    PageHero,
    SearchFilters,
    SearchForm,
    PaginationMenu
  },

  mixins: [],

  data: () => {
    return {
      searchQuery: '',
      filters: [],
      searchTypes,
      searchData: clone(searchData),
      isLoadingSearch: false,
      isLoadingFilters: false,
      isFiltersVisible: false,
      isSearchMapVisible: false,
      breadcrumb: [
        {
          to: {
            name: 'index'
          },
          label: 'Home'
        }
      ],
      titleColumnWidth: 300,
      windowWidth: '',
      datasetFilters: [...datasetFilters],
      PublicationDatePicked: 'Any time',
      advancedMatch: 'Any of the words'
    }
  },

  computed: {
    /**
     * Compute search type
     * @returns {String}
     */
    searchType: function() {
      const searchTypeQuery = pathOr('', ['query', 'type'], this.$route)
      const searchType = find(propEq('type', searchTypeQuery), this.searchTypes)

      return defaultTo(head(this.searchTypes), searchType)
    },

    tableData: function() {
      return propOr([], 'items', this.searchData)
    },

    tableMetadata: function() {
      return propOr(new Map(), 'kCoreItems', this.searchData)
    },

    /**
     * Compute which search results component to display based on the type of search
     * @returns {Function}
     */
    searchResultsComponent: function() {
      return defaultTo('', searchResultsComponents[this.$route.query.type])
    },

    /**
     * Compute the current search page based off the limit and the offset
     */
    curSearchPage: function() {
      return this.searchData.skip / this.searchData.limit + 1
    },

    /**
     * Compute the search heading
     * This data could be set at a specific time, such as when the active
     * tab is set
     * @returns {String}
     */
    searchHeading: function() {
      const query = pathOr('', ['query', 'q'], this.$route)

      const searchTypeLabel = compose(
        propOr('', 'label'),
        find(propEq('type', this.$route.query.type))
      )(this.searchTypes)

      let searchHeading = `${this.searchData.total} ${searchTypeLabel}`

      return query === '' ? searchHeading : `${searchHeading} for “${query}”`
    },

    /**
     * Compute selected filters
     * @returns {Array}
     */
    selectedFilters: function() {
      return compose(
        filter(propEq('value', true)),
        flatten,
        pluck('items')
      )(this.filters)
    },

    /**
     * Compute active filters
     * @returns {Array}
     */
    activeFilters: function() {
      return compose(
        filter(propEq('value', true)),
        flatten,
        pluck('filters')
      )(this.filters)
    },

    /**
     * Compute dialog header based on how many active filters
     * @returns {String}
     */
    activeFiltersLabel: function() {
      const activeFilterLength = this.activeFilters.length
      return activeFilterLength ? `Filters (${activeFilterLength})` : `Filters`
    },

    q: function() {
      return this.$route.query.q || ''
    },

    /**
     * True if user is on a small screen (mobile)
     * @returns {Boolean}
     */
    isMobile: function() {
      return this.windowWidth <= 500
    }
  },

  watch: {
    '$route.query.type': function(val) {
      /**
       * Clear table data so the new table that is rendered can
       * properly render data and account for any missing data
       */
      this.searchData = clone(searchData)
      if (val === 'dataset' && !this.$route.query.datasetFilters) {
        this.datasetFilters = [...datasetFilters]
      }
      this.fetchResults()
    },

    '$route.query.q': {
      handler: function(val) {
        if (val) {
          this.searchQuery = this.$route.query.q
          this.fetchResults()
        }
      },
      immediate: true
    }
  },

  beforeMount: function() {
    this.windowWidth = window.innerWidth
  },
  /**
   * Check the searchType param in the route and set it if it doesn't exist
   * Shrink the title column width if on mobile
   */
  mounted: function() {
    this.autocomplete(document.getElementById("myInput"), countries);
    if (!this.$route.query.type) {
      const firstTabType = compose(propOr('', 'type'), head)(searchTypes)

      this.$router.replace({ query: { type: firstTabType } })
    } else {
      /**
       * Set the searchData from query params
       * Need to convert skip and limit from strings to numbers
       */
      const queryParams = {
        skip: Number(this.$route.query.skip || searchData.skip),
        limit: Number(this.$route.query.limit || searchData.limit),
        q: this.$route.query.q || ''
      }

      this.searchData = { ...this.searchData, ...queryParams }

      if (this.$route.query.datasetFilters) {
        this.datasetFilters = Array.isArray(this.$route.query.datasetFilters)
          ? this.$route.query.datasetFilters
          : [this.$route.query.datasetFilters]
      }

      this.fetchResults()

    if (window.innerWidth <= 768) this.titleColumnWidth = 150
    window.onresize = () => this.onResize(window.innerWidth)
    }

  },

  methods: {
    /**
     * Update search limit based on pagination number selection
     * @param {Number} limit
     */
    updateDataSearchLimit: function(limit) {
      this.searchData.skip = 0

      const newLimit = limit === 'View All' ? this.searchData.total : limit

      this.searchData.limit = newLimit
      this.$router.replace({
        query: { ...this.$route.query, limit: newLimit, skip: 0 }
      })
      this.fetchResults()
    },

    queryFunction(query) {
      const url = `http://130.216.216.55/search?query=${query}`

      const req = http.get(url, res => {

        let data = "";
        res.setEncoding('utf8');
        res.on("data", d => {
          data += d
        })
        res.on("end", () => {
          var parsedJSON = JSON.parse(data)
          var keywordArr = parsedJSON["filters"]["keywords"]
          var authorArr = parsedJSON["filters"]["authors"]
          var itemsArr = this.returnItems(parsedJSON)
          this.searchData.items = itemsArr
          this.searchData.keywords = keywordArr
          this.searchData.authors = authorArr
          this.searchData.total = itemsArr.length
          console.dir(this.searchData)
          // this.searchData.items = [{"id":1234, "banner": "https://raw.githubusercontent.com/SPARC-FAIR-Codeathon/aqua/main/src/assets/images/logo_aqua-1.jpg", "name":"mock dataset", "embargo": true,
          // "description": "my description", "doi": "doi-12345", "createdAt": '2021-07-19T10:23:08.933087', "updatedAt": '2021-07-19T10:23:08.933087'},
          // {"id":12345, "banner": "https://raw.githubusercontent.com/SPARC-FAIR-Codeathon/aqua/main/src/assets/images/logo_aqua-1.jpg", "name":"mock dataset", "embargo": true,
          // "description": "my description", "doi": "doi-12345", "createdAt": '2021-07-19T10:23:08.933087', "updatedAt": '2021-07-19T10:23:08.933087'}]
        })
      })

      req.on('error', error => {
        console.error(error)
      })
      req.end()
    },

    returnItems(parsedJson) {
      var itemsArray = []
      for (var rank of parsedJson["sorts"]["ranking"]) {
        var object = parsedJson["hits"][rank];
        itemsArray.push(object)
      }
      return itemsArray
    },

    seeMoreSection() {
      document.getElementById("additional-filters-div").style.display = "block"
      document.getElementById("see-more-btn").style.display = "none"
    },

    seeLessSection() {
      document.getElementById("additional-filters-div").style.display = "none"
      document.getElementById("see-more-btn").style.display = "block"
    },

    resetFilters() {

    },

    showAdvancedSearch() {
      if (document.getElementById("div-advanced-search").style.display === "block") {
        document.getElementById("div-advanced-search").style.display = "none"
      } else {
        document.getElementById("div-advanced-search").style.display = "block"
      }
    },

    autocomplete(inp, arr) {
      /*the autocomplete function takes two arguments,
      the text field element and an array of possible autocompleted values:*/
      var currentFocus;
      /*execute a function when someone writes in the text field:*/
      inp.addEventListener("input", function(e) {
          var a, b, i, val = this.value;
          /*close any already open lists of autocompleted values*/
          closeAllLists();
          if (!val) { return false;}
          currentFocus = -1;
          /*create a DIV element that will contain the items (values):*/
          a = document.createElement("DIV");
          a.setAttribute("id", this.id + "autocomplete-list");
          a.setAttribute("class", "autocomplete-items");
          /*append the DIV element as a child of the autocomplete container:*/
          this.parentNode.appendChild(a);
          /*for each item in the array...*/
          for (i = 0; i < arr.length; i++) {
            /*check if the item starts with the same letters as the text field value:*/
            if (arr[i].substr(0, val.length).toUpperCase() == val.toUpperCase()) {
              /*create a DIV element for each matching element:*/
              b = document.createElement("DIV");
              /*make the matching letters bold:*/
              b.innerHTML = "<strong>" + arr[i].substr(0, val.length) + "</strong>";
              b.innerHTML += arr[i].substr(val.length);
              /*insert a input field that will hold the current array item's value:*/
              b.innerHTML += "<input type='hidden' value='" + arr[i] + "'>";
              /*execute a function when someone clicks on the item value (DIV element):*/
                  b.addEventListener("click", function(e) {
                  /*insert the value for the autocomplete text field:*/
                  inp.value = this.getElementsByTagName("input")[0].value;
                  /*close the list of autocompleted values,
                  (or any other open lists of autocompleted values:*/
                  closeAllLists();
              });
              a.appendChild(b);
            }
          }
      });
      /*execute a function presses a key on the keyboard:*/
      inp.addEventListener("keydown", function(e) {
          var x = document.getElementById(this.id + "autocomplete-list");
          if (x) x = x.getElementsByTagName("div");
          if (e.keyCode == 40) {
            /*If the arrow DOWN key is pressed,
            increase the currentFocus variable:*/
            currentFocus++;
            /*and and make the current item more visible:*/
            addActive(x);
          } else if (e.keyCode == 38) { //up
            /*If the arrow UP key is pressed,
            decrease the currentFocus variable:*/
            currentFocus--;
            /*and and make the current item more visible:*/
            addActive(x);
          } else if (e.keyCode == 13) {
            /*If the ENTER key is pressed, prevent the form from being submitted,*/
            e.preventDefault();
            if (currentFocus > -1) {
              /*and simulate a click on the "active" item:*/
              if (x) x[currentFocus].click();
            }
          }
      });

      function addActive(x) {
        /*a function to classify an item as "active":*/
        if (!x) return false;
        /*start by removing the "active" class on all items:*/
        removeActive(x);
        if (currentFocus >= x.length) currentFocus = 0;
        if (currentFocus < 0) currentFocus = (x.length - 1);
        /*add class "autocomplete-active":*/
        x[currentFocus].classList.add("autocomplete-active");
      }
      function removeActive(x) {
        /*a function to remove the "active" class from all autocomplete items:*/
        for (var i = 0; i < x.length; i++) {
          x[i].classList.remove("autocomplete-active");
        }
      }
      function closeAllLists(elmnt) {
        /*close all autocomplete lists in the document,
        except the one passed as an argument:*/
        var x = document.getElementsByClassName("autocomplete-items");
        for (var i = 0; i < x.length; i++) {
          if (elmnt != x[i] && elmnt != inp) {
          x[i].parentNode.removeChild(x[i]);
        }
      }
    };
    /*execute a function when someone clicks in the document:*/
    document.addEventListener("click", function (e) {
        closeAllLists(e.target);
    });
  },

    /**
     * Set active filters based on the query params
     * @params {Array} filters
     * @returns {Array}
     */
    setActiveFilters: function(filters) {
      const tags = (this.$route.query.tags || '').toLowerCase().split(',')

      return filters.map(category => {
        category.filters.map(filter => {
          const hasTag = tags.indexOf(filter.key.toLowerCase())
          filter.value = hasTag >= 0
          return filter
        })

        return category
      })
    },

    /**
     * Figure out which source to fetch results from based on the
     * type of search
     */
    fetchResults: function() {
      const source = propOr('contentful', 'dataSource', this.searchType)

      const searchSources = {
        contentful: this.fetchFromContentful,
        algolia: this.fetchFromAlgolia,
        aqua: this.fetchFromAqua
      }

      if (typeof searchSources[source] === 'function') {
        searchSources[source]()
      }
    },

    handleSortChange: function(payload) {
      handleSortChange(
        this.searchType.dataSource,
        this.searchData,
        this.fetchResults,
        payload
      )
    },

    /**
     * Get Search results
     * This is using fetch from the Algolia API
     */
    fetchFromAlgolia: function() {
      this.isLoadingSearch = true

      const searchType = pathOr('', ['query', 'type'], this.$route)
      const embargoedFilter = getEmbargoedFilter(
        searchType,
        this.datasetFilters
      )
      const query = this.$route.query.q
      const organizationNameFilter =
        searchType === 'simulation' ? "IT'IS Foundation" : 'SPARC Consortium'

      const filters = `${
        embargoedFilter === undefined || embargoedFilter.length === 0
          ? ''
          : embargoedFilter + ' AND '
      }organizationName:"${organizationNameFilter}"`

      algoliaPennseiveIndex
        .search(query, {
          hitsPerPage: this.searchData.limit,
          page: this.curSearchPage - 1,
          filters: filters
        })
        .then(response => {
          const searchData = {
            items: response.hits,
            total: response.nbHits
          }
          this.searchData = mergeLeft(searchData, this.searchData)
        })
        .finally(() => {
          // console.log(`fromAlgolia: ${this.searchData}`)
          // console.dir(this.searchData)
          this.fetchItemsFromKCore()
        })
    },

    fetchItemsFromKCore: function() {
      // Get all the Penseive items and find their corresponding KCore item by searching for their doi
      const dois = this.searchData.items.map(
        item => `item.docid:"DOI:${item.doi}"`
      )
      const doisFilter = dois.join(' OR ')
      algoliaKCoreIndex
        .search('', {
          filters: doisFilter
        })
        .then(response => {
          response.hits.map(hit =>
            this.searchData.kCoreItems.set(
              hit.item.docid.replace('DOI:', ''),
              hit
            )
          )
        })
        .finally(() => {
          console.log(`fromKCore: ${this.searchData}`)
          console.dir(this.searchData)
          this.isLoadingSearch = false
        })
    },

    /**
     * Get search results
     * This is using the contentful.js client
     */
    fetchFromContentful: function() {
      this.isLoadingSearch = true

      const tags = this.$route.query.tags || undefined

      // Keep the original search data limit to get all organs before pagination
      const origSearchDataLimit = this.searchData.limit
      this.$route.query.type === 'organ' ? (this.searchData.limit = 999) : ''

      client
        .getEntries({
          content_type: this.$route.query.type,
          query: this.$route.query.q,
          limit: this.searchData.limit,
          skip: this.searchData.skip,
          order: this.searchData.order,
          include: 2,
          'fields.tags[all]': tags
        })
        .then(async response => {
          this.searchData = { ...response, order: this.searchData.order }
          if (
            this.$route.query.type === 'organ' &&
            origSearchDataLimit !== 999
          ) {
            this.searchData.items = await this.removeOrganNoDatasets()
            // Reset search data values for pagination
            this.searchData.limit = origSearchDataLimit
            this.searchData.skip == 0
              ? this.searchData.items.length > this.searchData.limit
                ? this.searchData.items.splice(this.searchData.limit)
                : (this.searchData.total = this.searchData.items.length)
              : ''
          }
        })
        .catch(() => {
          this.searchData = clone(searchData)
        })
        .finally(() => {
          console.log(`fromContentful: ${this.searchData}`)
          console.dir(this.searchData)
          this.isLoadingSearch = false
        })
    },

    // fetch from AQUA
    fetchFromAqua: function() {
      this.isLoadingSearch = true
      this.searchData.limit = 10
      this.queryFunction(this.$route.query.q)

      // this.searchData.items = [{"id":1234, "banner": "https://raw.githubusercontent.com/SPARC-FAIR-Codeathon/aqua/main/src/assets/images/logo_aqua-1.jpg", "name":"mock dataset", "embargo": true,
      // "description": "my description", "doi": "doi-12345", "createdAt": '2021-07-19T10:23:08.933087', "updatedAt": '2021-07-19T10:23:08.933087'},
      // {"id":12345, "banner": "https://raw.githubusercontent.com/SPARC-FAIR-Codeathon/aqua/main/src/assets/images/logo_aqua-1.jpg", "name":"mock dataset", "embargo": true,
      // "description": "my description", "doi": "doi-12345", "createdAt": '2021-07-19T10:23:08.933087', "updatedAt": '2021-07-19T10:23:08.933087'}]
      // var doiss = this.searchData.items.map(
      //   item => `item.docid:"DOI:${item.doi}"`
      // )
      // this.searchData.kCoreItems = doiss
      // console.log(doiss)
      // response.hits.map(hit =>
      //   this.searchData.kCoreItems.set(
      //     hit.item.docid.replace('DOI:', ''),
      //     hit
      //   )
      // )
      this.isLoadingSearch = false
    },

    /**
     * Get organ details from discover api
     * @param {Object}
     * @returns {Object}
     */
    getOrganDetails: function(organ) {
      const organName = pathOr('', ['fields', 'name'], organ)

      const projectSection = pathOr(
        organName,
        ['fields', 'projectSection', 'fields', 'title'],
        organ
      )
      return this.$axios
        .get(
          `${
            process.env.discover_api_host
          }/search/datasets?query=${projectSection.toLowerCase()}&limit=1`
        )
        .then(response => {
          return response.data
        })
    },

    /**
     * Check if an organ has datasets
     * @param {Object}
     * @return {Boolean}
     */
    hasDatasets: function(organData) {
      return organData.totalCount > 0
    },

    /**
     * Remove organs that do not have any
     * associated datasets from the search data
     * @returns {Array}
     */
    removeOrganNoDatasets: async function() {
      const results = await Promise.all(
        this.searchData.items.map(organ => this.getOrganDetails(organ))
      )
      return this.searchData.items.filter((organ, index) =>
        this.hasDatasets(results[index])
      )
    },

    /**
     * Get filters based on the search type
     */
    fetchFilters: function() {
      this.filters = []
      this.isLoadingFilters = true

      client
        .getEntry(this.searchType.filterId, { include: 2 })
        .then(response => {
          const filters = transformFilters(response.fields)
          this.filters = this.setActiveFilters(filters)
        })
        .catch(() => {
          this.filters = []
        })
        .finally(() => {
          this.isLoadingFilters = false
        })
    },

    /**
     * Update offset
     */
    onPaginationPageChange: function(page) {
      const offset = (page - 1) * this.searchData.limit
      this.searchData.skip = offset

      this.$router.replace({
        query: { ...this.$route.query, skip: offset }
      })

      this.fetchResults()
    },

    /**
     * Submit search
     */
    submitSearch: function() {
      this.searchData.skip = 0

      const query = mergeLeft({ q: this.searchQuery }, this.$route.query)
      this.$router.replace({ query })
    },

    /**
     * Submit search
     */
    clearSearch: function() {
      this.searchData.skip = 0

      const query = { ...this.$route.query, q: '' }
      this.$router.replace({ query })
    },

    /**
     * Clear filter's value
     * @param {Number} filterIdx
     * @param {Number} itemIdx
     */
    clearFilter: function(filterIdx, itemIdx) {
      const filters = assocPath(
        [filterIdx, 'filters', itemIdx, 'value'],
        false,
        this.filters
      )
      this.filters = filters
      this.setTagsQuery()
    },

    /**
     * Set the tags query parameter in the router
     */
    setTagsQuery: function() {
      const filterVals = this.activeFilters.map(filter => {
        return filter.key
      })

      const queryParamTags = pathOr('', ['query', 'tags'], this.$route)
      if (equals(filterVals, queryParamTags.split(','))) {
        return
      }

      const tags = { tags: filterVals.join(',') }

      const query = { ...this.$route.query, ...tags }
      this.$router.replace({ query }).then(() => {
        this.fetchResults()
      })
    },

    /**
     * responds to a click in the anatomical map popup by adding a filter
     * @param {String} label
     */
    onMapClick: function(label) {
      const { query } = this.$route
      const labelKey = label.toLowerCase()

      // short circuit if nothing has changed
      if (
        query.tags === labelKey ||
        find(t => t === labelKey, (query.tags || '').split(','))
      ) {
        return
      }

      const newTags = query.tags ? [query.tags, labelKey].join(',') : labelKey

      this.filters = this.filters.map(f => ({
        ...f,
        filters: f.filters.map(subFilter => {
          if (subFilter.label === label) {
            return {
              ...subFilter,
              value: true
            }
          }
          return subFilter
        })
      }))

      this.$router
        .replace({
          query: {
            ...query,
            tags: newTags
          }
        })
        .then(() => {
          this.fetchResults()
        })
    },

    /**
     * Adjust the Title column width when
     * on smaller screens or mobile
     * @param {Number} width
     */
    onResize: function(width) {
      width <= 768
        ? (this.titleColumnWidth = 150)
        : (this.titleColumnWidth = 300)
      this.windowWidth = width
    },

    /**
     * Compute search column span
     * Determined if the searchType === 'dataset'
     */
    searchColSpan(viewport) {
      const isDataset = this.searchType.type === 'dataset'
      const viewports = {
        sm: isDataset ? 24 : 24,
        md: isDataset ? 18 : 24,
        lg: isDataset ? 20 : 24
      }

      return viewports[viewport] || 24
    },

    /**
     * Set datset filters
     */
    setDatasetFilter() {
      this.$router.replace({
        query: {
          type: 'dataset',
          q: this.$route.query.q,
          datasetFilters: this.datasetFilters,
          skip: 0,
          limit: 10
        }
      })

      /**
       * Clear table data so the new table that is rendered can
       * properly render data and account for any missing data
       */
      this.searchData = clone(searchData)
      this.fetchResults()
    }
  }
}


</script>

<style scoped lang="scss">
@import '../../assets/_variables.scss';

.page-hero {
  padding-bottom: 1.3125em;
}
.search-tabs__container {
  margin-top: 2rem;
  padding-top: 0.5rem;
  background-color: white;
  border: 0.1rem solid $purple-gray;
  h3 {
    padding-left: 0.75rem;
    font-weight: 600;
    font-size: 1.5rem;
  }
}
.search-bar__container {
  margin-top: 1em;
  padding: 0.75rem;
  border: 0.1rem solid $purple-gray;
  background: white;
  h5 {
    line-height: 1rem;
    font-weight: 600;
    font-size: 1rem;
  }
  .arrow-span {
    border-color: blueviolet transparent;
    border-style: solid;
    border-width: 5px 4px 0 4px;
    width: 0;
    height: 0;
    margin-left: -2px;
    top: 50%;
    margin-top: -2px;
    position: absolute;
    cursor: pointer;
    // vertical-align: middle
  }
}
.search-tabs {
  display: flex;
  list-style: none;
  overflow: auto;
  margin: 0 0 0 0;
  padding: 0 0;
  outline: 0.1rem solid $median;
  li {
    width: 100%;
    text-align: center;
    color: $median;
  }
  li:last-child > a {
    border-right: none;
  }
}
.search-tabs__button {
  background: $light-purple;
  display: block;
  font-size: 0.75rem;
  font-weight: 500;
  outline: none;
  padding: 0;
  text-decoration: none;
  text-transform: uppercase;
  border-right: 0.1rem solid $median;
  line-height: 3.5rem;
  @media (min-width: 48em) {
    font-size: 1.25rem;
    font-weight: 600;
    text-transform: none;
  }
  &:hover,
  &:focus,
  &.active {
    color: white;
    background-color: $median;
    font-weight: 500;
  }
}
.page-wrap {
  padding-bottom: 1em;
  @media (min-width: 48em) {
    padding-bottom: 3em;
  }
}
.table-wrap {
  background: #fff;
  border: 1px solid rgb(228, 231, 237);
  padding: 16px;
}
::v-deep .el-pagination {
  margin-top: 1.5em;
  text-align: right;
  background-color: transparent;
  @media screen and (max-width: 28em) {
    margin-top: 5px;
    padding-left: 0;
    .btn-prev {
      padding-left: 0;
    }
  }
  button {
    background-color: transparent;
  }
}
.search-heading {
  align-items: center;
  margin-top:30px;
  display: flex;
  margin-bottom: 1em;
  justify-content: space-between;
  @media screen and (max-width: 28em) {
    flex-direction: column;
    align-items: flex-start;
    margin-bottom: 0;
  }
  p {
    font-size: 0.875em;
    flex-shrink: 0;
    margin: 2em 0 0 0;
  }
}
::v-deep {
  .el-table td {
    vertical-align: top;
  }
  .el-table .cell {
    word-break: normal;
  }
}
.btn__filters {
  align-items: center;
  background: none;
  border: none;
  color: $median;
  display: flex;
  font-size: 0.875em;
  outline: none;
  padding: 0;
  &[disabled] {
    opacity: 0.7;
  }
  &:not([disabled]) {
    &:hover,
    &:focus {
      cursor: pointer;
      text-decoration: underline;
    }
  }
  .svg-icon {
    margin-right: 0.3125rem;
  }
}
.active__filter__wrap,
.active__filter__wrap-category {
  display: inline;
}
.active__filter__wrap .el-tag {
  margin: 0.5em 1em 0.5em 0;
}
.filter__wrap {
  padding-right: 1em;
}
.radio-button:after {
  background: #ffa500
}
.radio-button:checked:after {
     background-color: blueviolet;
 }
 .el-checkbox__input.is-checked .el-checkbox__inner, .el-checkbox__input.is-indeterminate .el-checkbox__inner {
   background-color: #0077cc !important
 }

 .el-col-sm-24 {
   width: 26%
 }
 .el-col-md-18 {
   width: 74%
 }

.dataset-filters {
  .filter-headers {
    font-weight: 600
  }
  .dataset-filters__filter-group {
    border-bottom: 1px solid #dbdfe6;
    padding-bottom: 0.5rem;
  }
  .filtering-section {
    max-height: 100px;
    overflow-y: scroll;
    overflow-x: hidden;
  }
  padding: 0.5rem 1rem 1rem;
  h2,
  h3 {
    font-size: 1.125rem;
    font-weight: normal;
    line-height: 1.2;
  }
  h2 {
    border-bottom: 1px solid #dbdfe6;
    margin-bottom: 0.5rem;
    padding-bottom: 0.5rem;
  }
  h3 {
    font-size: 0.875rem;
    text-transform: uppercase;
  }
  ::v-deep .el-checkbox-group {
    display: flex;
    flex-direction: column;
  }
  ::v-deep .el-checkbox__label {
    color: black;
  }
  ::-webkit-scrollbar {
    background: white;
    // border: 1px solid black;
    border: none;
    border-radius: 4px;
    width: 10px;
  }
  ::-webkit-scrollbar-thumb {
   background: #909090;
   border-radius: 5px;
   width: 10px;
  }
  ::-webkit-scrollbar-track {
    background-color: white;
    border: 1px solid #D3D3D3;
    border-radius: 5px;
    // width: 20px
  }
  .see-more-btn {
    background-color: transparent;
    color: #8300BF;
    border: 1px solid #8300BF;
    border-radius: 3px;
    width: 100%;
    height: 30px;
    margin: 10px 0;
    padding: 5px 10px;
    font-size: 13px;
    opacity: 0.9;
    cursor: pointer;
  }

  input {
    border: 1px solid transparent;
    background-color: #f1f1f1;
    padding: 10px;
    font-size: 16px;
  }
  input[type=text] {
    background-color: #f1f1f1;
    width: 100%;
  }
  input[type=submit] {
    background-color: DodgerBlue;
    color: #fff;
  }
  #myInputautocomplete-list {
    padding: 10px;

  }
}


</style>
