/* file: xavier_initializer_impl.i */
/*******************************************************************************
* Copyright 2014-2016 Intel Corporation
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*******************************************************************************/

/*
//++
//  Implementation of Xavier algorithm
//--
*/

#include "service_rng.h"
#include "service_math.h"
#include "service_tensor.h"


#ifndef __XAVIER_INITIALIZER_IMPL_I__
#define __XAVIER_INITIALIZER_IMPL_I__

using namespace daal::internal;
using namespace daal::services;

namespace daal
{
namespace algorithms
{
namespace neural_networks
{
namespace initializers
{
namespace xavier
{
namespace internal
{

template<typename algorithmFPType, Method method, CpuType cpu>
void XavierKernel<algorithmFPType, method, cpu>::compute(const initializers::Input *input,
        const xavier::Parameter *parameter, initializers::Result *result)
{
    UniformRng<algorithmFPType,cpu> rng(parameter->seed);

    SharedPtr<Tensor> resultTensor  = result->get(initializers::value);

    WriteOnlySubtensor<algorithmFPType, cpu, Tensor> resultSubtensor(resultTensor.get(), 0, 0, 0, resultTensor->getDimensions()[0]);
    algorithmFPType *resultArray = resultSubtensor.get();

    size_t nDims = resultTensor->getNumberOfDimensions();
    size_t nIn = parameter->layer->getLayerInput()->get(layers::forward::data)->getSize(1, nDims - 1);
    size_t nOut = parameter->layer->getLayerResult()->get(layers::forward::value)->getSize(1, nDims - 1);

    algorithmFPType a = daal::internal::Math<double,cpu>::sSqrt(6.0 / ((double)nIn + (double)nOut));

    rng.uniform(resultTensor->getSize(), -a, a, resultArray);
}

} // internal
} // namespace xavier
} // namespace initializers
} // namespace neural_networks
} // namespace algorithms
} // namespace daal

#endif