import service from '@/utils/request'

export const getChannelList = (params) => {
    return service({
      url: '/fabricClient/getChannelList',
      method: 'get',
      params
    })
  }

  // export const getBlockList = (params) => {
  //   return service({
  //     url: '/fabricClient/getChannelList',
  //     method: 'get',
  //     params
  //   })
  // }