<template>
  <el-table
    :data="tableData"
    :show-header="false"
    empty-text="No Results"
    @sort-change="onSortChange"
  >
    <el-table-column prop="banner" label="Image" width="160">
      <template slot-scope="scope">

        <nuxt-link
          :to="{
            name: 'datasets-datasetId',
            params: { datasetId: scope.row.id },
            query: {
              type: $route.query.type
            }
          }"
          class="img-dataset"
        >
          <img
            :src="scope.row.banner"
            :alt="`Banner for ${scope.row.name}`"
            height="128"
            width="128"
          />
          <sparc-pill v-if="scope.row.embargo">
            Embargoed
          </sparc-pill>
        </nuxt-link>

      </template>
    </el-table-column>
    <el-table-column
      min-width="400"
      sortable="custom"
      :sort-orders="sortOrders"
    >
      <template slot-scope="scope">
        <nuxt-link
          :to="{
            name: 'datasets-datasetId',
            params: { datasetId: scope.row.id },
            query: {
              type: $route.query.type
            }
          }"
        v-html="scope.row.name">
          {{ scope.row.name }}
        </nuxt-link>
        <div class="mt-8 mb-8" v-html="scope.row.description" style="color:#484848">
          {{ scope.row.description }}
        </div>
        <table class="property-table">
          <tr
            v-for="(property, index) in PROPERTY_DATA"
            v-show="
              property.propPath === 'firstPublishedAt' ||
                getPropertyValue(tableMetadata.get(scope.row.doi), property)
            "
            :key="index"
          >
            <td class="property-name-column">
              {{ property.displayName }}
            </td>
            <td>
              {{
                property.propPath === 'firstPublishedAt'
                  ? formatDate(scope.row.firstPublishedAt) +
                    ' (Last updated ' +
                    formatDate(scope.row.firstPublishedAt) +
                    ')'
                  : getPropertyValue(tableMetadata.get(scope.row.doi), property)
              }}
            </td>
          </tr>
        </table>
        <div style="margin-top:15px">
          <svg version="1.1" id="Capa_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
             width="20px" height="20px" fill="blueviolet" viewBox="0 0 507.45 507.45" style="cursor:pointer;enable-background:new 0 0 507.45 507.45;"
             xml:space="preserve">
          <g>
            <g id="share-alt">
              <path d="M408,178.5c-20.4,0-38.25,7.65-51,20.4L175.95,94.35c2.55-5.1,2.55-12.75,2.55-17.85C178.5,33.15,145.35,0,102,0
                S25.5,33.15,25.5,76.5S58.65,153,102,153c20.4,0,38.25-7.65,51-20.4l181.05,104.55c-2.55,5.1-2.55,12.75-2.55,17.85
                c0,5.1,0,12.75,2.55,17.85L153,379.95c-12.75-12.75-30.6-20.4-51-20.4c-40.8,0-73.95,33.15-73.95,73.95S61.2,507.45,102,507.45
                s73.95-33.15,73.95-73.95c0-5.1,0-10.2-2.55-17.85L354.45,308.55c12.75,12.75,30.6,20.4,51,20.4c43.35,0,76.5-33.15,76.5-76.5
                C481.95,209.1,451.35,178.5,408,178.5z"/>
            </g>
          </g>
          <g>
          </g>
          <g>
          </g>
          <g>
          </g>
          <g>
          </g>
          <g>
          </g>
          <g>
          </g>
          <g>
          </g>
          <g>
          </g>
          <g>
          </g>
          <g>
          </g>
          <g>
          </g>
          <g>
          </g>
          <g>
          </g>
          <g>
          </g>
          <g>
          </g>
          </svg>
          <!-- <svg-icon
            icon="icon-share-twitter"
            height="25"
            width="25"
            fill="blueviolet"
            style="margin-bottom:8px;margin-left: 3px;cursor:pointer;fill:blueviolet"
          >

          </svg-icon> -->
        </div>
      </template>
    </el-table-column>
  </el-table>
</template>


<script>
import SparcPill from '@/components/SparcPill/SparcPill.vue'
import FormatDate from '@/mixins/format-date'
import StorageMetrics from '@/mixins/bf-storage-metrics'
import { onSortChange } from '@/pages/data/utils'
import { pathOr } from 'ramda'
import _ from 'lodash'

export default {
  name: 'DatasetSearchResults',

  components: { SparcPill },

  mixins: [FormatDate, StorageMetrics],

  props: {
    tableData: {
      type: Array,
      default: () => []
    },
    tableMetadata: {
      type: Map,
      default: () => new Map()
    }
  },

  data() {
    return {
      sortOrders: ['ascending', 'descending'],
      PROPERTY_DATA: [
        {
          displayName: 'Anatomical Structure',
          // propPath: 'anatomy.organ'
          // propPath: 'item.anatomy[0].organ'
          propPath: 'anatomy[0]'
        },
        {
          displayName: 'Species',
          // propPath: 'organisms.primary[0].species.name'
          propPath: 'item.organisms[0].species.name'
        },
        {
          displayName: 'Techniques',
          propPath: 'item.techniques'
        },
        {
          displayName: 'Samples',
          propPath: 'samples'
        },
        {
          displayName: 'Subjects',
          propPath: 'subjects'
        },
        // aqua json returns firstPublishedAt instead of createdAt
        {
          displayName: 'Publication Date',
          propPath: 'firstPublishedAt'
        },
        // {
        //   displayName: 'Publication Date',
        //   propPath: 'createdAt'
        // },
        {
          displayName: 'Includes',
          propPath: 'publication'
        }
      ]
    }
  },

  computed: {
    /**
     * Compute if the search results are for simulations
     * @returns {Boolean}
     */
    areSimulationResults: function() {
      const searchType = pathOr('', ['query', 'type'], this.$route)
      return searchType === 'simulation'
    }
  },

  methods: {

    getPropertyValue: function(item, property) {
      if (item == undefined) {
        return undefined
      }
      switch (property.displayName) {
        case 'Anatomical Structure': {
          const organs = _.get(item, property.propPath)
          return organs
            ? organs.map(item => _.upperFirst(item.name)).join(', ')
            : undefined
        }
        case 'Includes': {
          return _.get(item, property.propPath) ? undefined : 'Publications'
        }
        case 'Samples': {
          const sampleCount = _.get(item, property.propPath + '.samples.count')
          const subjectCount = _.get(
            item,
            property.propPath + '.subjects.count'
          )
          return sampleCount && subjectCount
            ? `${sampleCount} samples from ${subjectCount} subjects`
            : undefined
        }
        case 'Techniques': {
          const techniques = _.get(item, property.propPath)
          return techniques
            ? techniques
                .map(item => _.upperFirst(item.keyword))
                .join(', ')
                .replaceAll(' technique', '')
            : undefined
        }
        default: {
          return _.get(item, property.propPath)
        }
      }
    },

    onSortChange: function(payload) {
      onSortChange(this, payload)
    }
  }
}
</script>

<style lang="scss" scoped>
@import '../../assets/_variables.scss';
.el-table {
  width: 100%;
}

.el-table--enable-row-hover .el-table__body tr {
  background-color: transparent;
}

.img-dataset {
  display: block;
  position: relative;
  .sparc-pill {
    font-size: 0.75rem;
    position: absolute;
    right: 0.25rem;
    top: 0.5rem;
  }
  img {
    display: block;
  }
}
.property-table {
  td {
    background-color: transparent;
    padding: 0.25rem 0 0 0;
    border: none;
  }
  background-color: transparent;
  border: none;
  padding: 0;
}
// The outermost bottom border of the table. Element UI adds psuedo elements to create the bottom table border that we must hide to remove
table:not([class^='el-table__'])::before {
  display: none;
}
.property-name-column {
  width: 160px;
  font-weight: bold;
}
</style>

<style lang="scss">
  div em {
    font-weight: 900;
    font-style: normal;
    color: black
  }
  .cell em {
    color: inherit;
    font-style: normal;
    font-weight: 900;
  }
</style>
