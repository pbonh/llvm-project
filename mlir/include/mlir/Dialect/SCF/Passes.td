//===-- Passes.td - SCF pass definition file ---------------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_SCF_PASSES
#define MLIR_DIALECT_SCF_PASSES

include "mlir/Pass/PassBase.td"

def SCFBufferize : FunctionPass<"scf-bufferize"> {
  let summary = "Bufferize the scf dialect.";
  let constructor = "mlir::createSCFBufferizePass()";
  let dependentDialects = ["memref::MemRefDialect"];
}

// Note: Making these canonicalization patterns would require a dependency
// of the SCF dialect on the Affine/Tensor/MemRef dialects or vice versa.
def SCFForLoopCanonicalization
    : FunctionPass<"for-loop-canonicalization"> {
  let summary = "Canonicalize operations within scf.for loop bodies";
  let constructor = "mlir::createSCFForLoopCanonicalizationPass()";
  let dependentDialects = ["AffineDialect", "tensor::TensorDialect",
                           "memref::MemRefDialect"];
}

def SCFForLoopPeeling
    : FunctionPass<"for-loop-peeling"> {
  let summary = "Peel `for` loops at their upper bounds.";
  let constructor = "mlir::createForLoopPeelingPass()";
  let options = [
    Option<"skipPartial", "skip-partial", "bool",
           /*default=*/"true",
           "Do not peel loops inside of the last, partial iteration of another "
           "already peeled loop.">
  ];
  let dependentDialects = ["AffineDialect"];
}

def SCFForLoopSpecialization
    : FunctionPass<"for-loop-specialization"> {
  let summary = "Specialize `for` loops for vectorization";
  let constructor = "mlir::createForLoopSpecializationPass()";
}

def SCFParallelLoopFusion : Pass<"parallel-loop-fusion"> {
  let summary = "Fuse adjacent parallel loops";
  let constructor = "mlir::createParallelLoopFusionPass()";
}

def SCFParallelLoopSpecialization
    : FunctionPass<"parallel-loop-specialization"> {
  let summary = "Specialize parallel loops for vectorization";
  let constructor = "mlir::createParallelLoopSpecializationPass()";
}

def SCFParallelLoopTiling : FunctionPass<"parallel-loop-tiling"> {
  let summary = "Tile parallel loops";
  let constructor = "mlir::createParallelLoopTilingPass()";
  let options = [
    ListOption<"tileSizes", "parallel-loop-tile-sizes", "int64_t",
               "Factors to tile parallel loops by",
               "llvm::cl::ZeroOrMore, llvm::cl::MiscFlags::CommaSeparated">,
    Option<"noMinMaxBounds", "no-min-max-bounds", "bool",
           /*default=*/"false",
           "Perform tiling with fixed upper bound with inbound check "
           "inside the internal loops">
  ];
  let dependentDialects = ["AffineDialect"];
}

def SCFForLoopRangeFolding
    : Pass<"for-loop-range-folding"> {
  let summary = "Fold add/mul ops into loop range";
  let constructor = "mlir::createForLoopRangeFoldingPass()";
}

#endif // MLIR_DIALECT_SCF_PASSES
