/*
	This file is part of solidity.

	solidity is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	solidity is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with solidity.  If not, see <http://www.gnu.org/licenses/>.
*/
// SPDX-License-Identifier: GPL-3.0

#include <libsolidity/experimental/analysis/FunctionCallGraph.h>

#include <libsolidity/experimental/analysis/Analysis.h>

using namespace solidity::frontend::experimental;
using namespace solidity::util;

FunctionCallGraph::FunctionCallGraph(Analysis& _analysis):
	m_analysis(_analysis),
	m_errorReporter(_analysis.errorReporter())
{
}

bool FunctionCallGraph::analyze(SourceUnit const& _sourceUnit)
{
	_sourceUnit.accept(*this);
	// TODO remove debug output before merge
	//std::cout << annotation().functionCallGraph << std::endl;
	return !m_errorReporter.hasErrors();
}

bool FunctionCallGraph::visit(FunctionDefinition const& _functionDefinition)
{
	solAssert(!m_currentFunction);
	m_currentFunction = &_functionDefinition;
	return true;
}

void FunctionCallGraph::endVisit(FunctionDefinition const&)
{
	// If we're done visiting a function declaration without said function referencing/calling
	// another function in its body - insert it into the graph without child nodes.
	annotation().functionCallGraph.edges.try_emplace(m_currentFunction, std::set<FunctionDefinition const*>{});
	m_currentFunction = nullptr;
}

bool FunctionCallGraph::visit(Identifier const& _identifier)
{
	auto callee = dynamic_cast<FunctionDefinition const*>(_identifier.annotation().referencedDeclaration);
	// Check that the identifier is within a function body and is a function, and add it to the graph
	// as an ``m_currentFunction`` -> ``callee`` edge.
	if (m_currentFunction && callee)
		add(m_currentFunction, callee);
	return true;
}

void FunctionCallGraph::add(FunctionDefinition const* _caller, FunctionDefinition const* _callee)
{
	annotation().functionCallGraph.edges[_caller].insert(_callee);
}

FunctionCallGraph::GlobalAnnotation& FunctionCallGraph::annotation()
{
	return m_analysis.annotation<FunctionCallGraph>();
}
