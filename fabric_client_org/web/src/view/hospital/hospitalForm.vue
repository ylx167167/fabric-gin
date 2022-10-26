<template>
  <div>
    <div class="gva-form-box">
      <el-form :model="formData" label-position="right" label-width="80px">
        <el-form-item label="医院名:">
          <el-input v-model="formData.name" clearable placeholder="请输入" />
        </el-form-item>
        <el-form-item label="等级:">
          <el-input v-model.number="formData.level" clearable placeholder="请输入" />
        </el-form-item>
        <el-form-item label="地址:">
          <el-input v-model="formData.address" clearable placeholder="请输入" />
        </el-form-item>
        <el-form-item label="电话:">
          <el-input v-model.number="formData.telephone" clearable placeholder="请输入" />
        </el-form-item>
        <el-form-item>
          <el-button size="mini" type="primary" @click="save">保存</el-button>
          <el-button size="mini" type="primary" @click="back">返回</el-button>
        </el-form-item>
      </el-form>
    </div>
  </div>
</template>

<script>
import {
  createHospital,
  updateHospital,
  findHospital
} from '@/api/hospital' //  此处请自行替换地址
import infoList from '@/mixins/infoList'
export default {
  name: 'Hospital',
  mixins: [infoList],
  data() {
    return {
      type: '',
      formData: {
        name: '',
        level: 0,
        address: '',
        telephone: 0,
      }
    }
  },
  async created() {
    // 建议通过url传参获取目标数据ID 调用 find方法进行查询数据操作 从而决定本页面是create还是update 以下为id作为url参数示例
    if (this.$route.query.id) {
      const res = await findHospital({ ID: this.$route.query.id })
      if (res.code === 0) {
        this.formData = res.data.rehospital
        this.type = 'update'
      }
    } else {
      this.type = 'create'
    }
  },
  methods: {
    async save() {
      let res
      switch (this.type) {
        case 'create':
          res = await createHospital(this.formData)
          break
        case 'update':
          res = await updateHospital(this.formData)
          break
        default:
          res = await createHospital(this.formData)
          break
      }
      if (res.code === 0) {
        this.$message({
          type: 'success',
          message: '创建/更改成功'
        })
      }
    },
    back() {
      this.$router.go(-1)
    }
  }
}
</script>

<style>
</style>
