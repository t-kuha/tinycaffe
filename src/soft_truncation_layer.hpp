#ifndef CAFFE_SOFT_TRUNCATION_LAYER_HPP_
#define CAFFE_SOFT_TRUNCATION_LAYER_HPP_

#include <vector>

#include "blob.hpp"
#include "layer.hpp"
#include "caffe.pb.h"

#include "neuron_layer.hpp"

namespace caffe {

template <typename Dtype>
class SoftTruncationLayer : public NeuronLayer<Dtype> {
 public:
  explicit SoftTruncationLayer(const LayerParameter& param)
      : NeuronLayer<Dtype>(param) {}

  virtual inline const char* type() const { return "SoftTruncation"; }

 protected:
  virtual void Forward_cpu(const vector<Blob<Dtype>*>& bottom,
      const vector<Blob<Dtype>*>& top);
  virtual void Forward_gpu(const vector<Blob<Dtype>*>& bottom,
      const vector<Blob<Dtype>*>& top);

};

}  // namespace caffe

#endif  // CAFFE_SOFT_TRUNCATION_LAYER_HPP_
