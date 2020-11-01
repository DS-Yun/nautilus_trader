# -------------------------------------------------------------------------------------------------
#  Copyright (C) 2015-2020 Nautech Systems Pty Ltd. All rights reserved.
#  https://nautechsystems.io
#
#  Licensed under the GNU Lesser General Public License Version 3.0 (the "License");
#  You may not use this file except in compliance with the License.
#  You may obtain a copy of the License at https://www.gnu.org/licenses/lgpl-3.0.en.html
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
# -------------------------------------------------------------------------------------------------

from cpython.datetime cimport datetime
from cpython.datetime cimport timedelta

from nautilus_trader.common.uuid cimport TestUUIDFactory
from nautilus_trader.core.message cimport Event
from nautilus_trader.core.uuid cimport UUID


cdef class TimeEvent(Event):
    cdef str _name


cdef class TimeEventHandler:
    cdef readonly TimeEvent event
    cdef readonly object handler

    cdef void handle(self) except *


cdef class Timer:
    cdef str _name
    cdef object _callback
    cdef timedelta _interval
    cdef datetime _start_time
    cdef datetime _next_time
    cdef datetime _stop_time
    cdef bint _expired

    cpdef TimeEvent pop_event(self, UUID event_id)
    cpdef void iterate_next_time(self, datetime now) except *
    cpdef void cancel(self) except *


cdef class TestTimer(Timer):
    cdef TestUUIDFactory _uuid_factory

    cpdef Event pop_next_event(self)
    cpdef list advance(self, datetime to_time)


cdef class LiveTimer(Timer):
    cdef object _internal

    cpdef void repeat(self, datetime now) except *
    cdef object _start_timer(self, datetime now)
